Zepto ($) ->
	Statusboard.State.debug = false

	Statusboard.State.bindings = []

	Statusboard.State.autorefresh_delay = switch window.location.host
		when "ceremony.weaver2gorman.com", "localhost:9010"
			delay = seconds_to_ms 10
		else
			delay = seconds_to_ms 45

	Statusboard.State.hashtag = "weaver2gorman"
	Statusboard.State.headline = "Rachel & David <span>& you</span>"
