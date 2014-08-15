Template.footer.helpers
	getFooterString: ->
		# info = Meteor.call('getServerInfo')
		year = "YEAR" #info.getBuildYear()
		month = "MONTH" #info.getBuildMonth()
		day = "DAY" #info.getBuildDay()
		version = "VERSION_XXXX" #info.getBuildVersion()
		copyrightYear = (new Date()).getFullYear()
		link = "<a href='http://bigbluebutton.org/' target='_blank'>http://bigbluebutton.org</a>"
		foot = "(c) #{copyrightYear} BigBlueButton Inc. [build #{version}-#{year}-#{month}-#{day}] - For more information visit #{link}"

Template.header.events
	"click .usersListIcon": (event) ->
		toggleUsersList()
	"click .chatBarIcon": (event) ->
		toggleChatbar()
	"click .videoFeedIcon": (event) ->
		toggleCam @ 
	"click .audioFeedIcon": (event) ->
		toggleVoiceCall @
	"click .muteIcon": (event) ->
		toggleMic @
	"click .signOutIcon": (event) ->
		userLogout getInSession("meetingId"), getInSession("userId"), true
	"click .hideNavbarIcon": (event) ->
		toggleNavbar()
	"click .settingsIcon": (event) ->
		alert "settings"
	"click .raiseHand": (event) -> 
		Meteor.call('userRaiseHand', @id)
	"click .lowerHand": (event) -> 
		Meteor.call('userLowerHand', @id)
	"click .whiteboardIcon": (event) ->
		toggleWhiteBoard()

Template.recordingStatus.rendered = ->
	$('button[rel=tooltip]').tooltip()

Template.makeButton.rendered = ->
	$('button[rel=tooltip]').tooltip()

# Gets called last in main template, just an easy place to print stuff out
Handlebars.registerHelper "doFinalStuff", ->
    console.log "-----Doing Final Stuff-----"

# These settings can just be stored locally in session, created at start up
Meteor.startup ->
	@SessionAmplify = _.extend({}, Session,
	  keys: _.object(_.map(amplify.store(), (value, key) ->
	    [
	      key
	      JSON.stringify(value)
	    ]
	  ))
	  set: (key, value) ->
	    Session.set.apply this, arguments
	    amplify.store key, value
	    return
	)

	SessionAmplify.set "display_usersList", true
	SessionAmplify.set "display_navbar", true
	SessionAmplify.set "display_chatbar", true
	SessionAmplify.set "display_whiteboard", true
	SessionAmplify.set "display_chatPane", true
	SessionAmplify.set 'inChatWith', "PUBLIC_CHAT"
	SessionAmplify.set "joinedAt", getTime()
	SessionAmplify.set "isSharingAudio", false
	SessionAmplify.set "inChatWith", 'PUBLIC_CHAT'
