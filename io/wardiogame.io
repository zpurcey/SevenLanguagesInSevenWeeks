#!/usr/bin/ioServer
Importer turnOff // for better error messages

About := "v1.0.2 (c) 2005, Ward Cunningham"

// Distributed under BSD open source license
// See http://c2.com/~ward/io/IoGame



////////////////////////////////////////////////////////////////////////////////

assert := method (	
	actual := self clone doMessage (thisMessage argAt(0))
	expected := sender doMessage (thisMessage argAt(1))
	if (expected != actual, 
		writeln (
			self type .. ": ", 
			thisMessage argAt(0) code,
			" ==> ", actual, " not ", expected
		)
		Error raise ("Assert Failed", self type .. ": " .. thisMessage argAt(0) code)
	)
)


Duration do (
	asString := method (
		s := (asNumber floor)
		if ((m := ((s / 60) floor)) < 2, return s asString .. " seconds")
		if ((h := ((m / 60) floor)) < 2, return m asString .. " minutes")
		if ((d := ((h / 24) floor)) < 2, return h asString .. " hours")
		if ((w := ((d /  7) floor)) < 2, return d asString .. " days")
		if ((m := ((d / 30) floor)) < 2, return w asString .. " weeks")
		if ((y := ((d /365) floor)) < 2, return m asString .. " months")
		y asString .. " years"
	)
	assert (setSeconds (5); asString, "5 seconds")
	assert (setSeconds (90); asString, "90 seconds")
	assert (setSeconds (120); asString, "2 minutes")
	assert (setDays (14); asString, "2 weeks")
	assert (setDays (20); asString, "2 weeks")
)


String do (
	html := method (
		self replace (" ", "<br>") replace ("_", "&nbsp;")
	)
	assert ("four of_a kind" html, "four<br>of&nbsp;a<br>kind")
)



////////////////////////////////////////////////////////////////////////////////

Suit := Object clone do (
	type := "Suit"
	name := Nil
	id := Nil
	color := "ffcccc"
	isWild := Nil
	setSlot ("==",
		 method (aSuit,
			(name == aSuit name) or aSuit isWild
		)
	)
	changeAll := method (aCardList,
		aCardList foreach (i, card,
			card suit := self
		)
		aCardList
	)
)

red := Suit clone do (name = "red"; color = "ffcccc"; id = 0)
yellow := Suit clone do (name = "yellow"; color = "ffff88"; id = 1)
green := Suit clone do (name = "green"; color =  "ccffaa"; id = 2)
blue := Suit clone do (name = "blue"; color =  "bbddff"; id = 3)

suits := list (red, yellow, green, blue)

assert ((red == red) isNil , Nil)
assert ((red == green), Nil)
assert (suits at (3) color, "bbddff")
assert (suits at (1) name, "yellow")
assert (suits at (green id), green)

WildSuit := Suit clone do (
	name = "wild"
	color = "dddddd"
	isWild = 1
	setSlot ("==", method (aSuit, self))
)

wild := WildSuit
wild id = 5

assert ((wild == yellow) isNil, Nil)
assert ((yellow == wild) isNil, Nil)

AnyOneSuit := WildSuit clone do (
	name := "any_suit"
	changeAll := method (aCardList, suits random changeAll (aCardList))
)

MixedSuit := WildSuit clone do (
	name := "_"
	changeAll := method (aCardList,
		aCardList foreach (i, card,
			card suit := suits at (i % suits count)
		)
	)
)


////////////////////////////////////////////////////////////////////////////////

Card := Object clone do (
	type := "Card"
	suit := Nil
	id := Nil
	heading := ""
	render := method (markup,
		markup html (
			"""<td valign=top align=center>""" .. heading .. """
			<table border=0 height=120 width=80>
			<tr><td align=center cellpadding=6 bgcolor=#"""
		)
		markup html (suit color)
		markup html (">")
		markup html (faceHtml)
		markup html ("</table>")
	)

	html := method (
		markup := Markup clone
		self render (markup)
		markup
	)
)

PlayingCard := Card clone do (
	type := "PlayingCard"
	rank := method (id % 10)
	suit := Nil
	asString := method (rank .. " " .. suit name)
	discard := method (playingDeck discard (self))
	faceHtml := method ("<font size=+4 face=Times>" .. rank .. "</font><br>" .. suit name html)
	actionHtml := method ("<br><a href=discard?" .. id .. ">discard</a>")
)

Number do (
	red := method (new := PlayingCard clone; new suit = Lobby red; new rank = self; new)
	yellow := method (new := PlayingCard clone; new suit = Lobby yellow; new rank = self; new)
	green := method (new := PlayingCard clone; new suit = Lobby green; new rank = self; new)
	blue := method (new := PlayingCard clone; new suit = Lobby blue; new rank = self; new)
)

assert ((1 green) type, "PlayingCard")
assert ((3 yellow) rank, 3)
assert ((5 red) suit, red)
assert (blue changeAll (list (1 red, 2 green)) at (1) suit, blue)
assert (wild changeAll (list (1 red, 2 green)) at (1) suit, wild)


GoalCard := Card clone do (
	type := "GoalCard"
	points := 0
	heading := method (points .. " points<br><br>")
	cards := 1
	suit := MixedSuit
	goal := "any old card"
	discard := method (goalDeck discard (self))
	faceHtml := method ("<a href=explain?" .. id .. ">" .. goal html .. "</a><br><br>" .. suit name html)
	example := list (1 red, 3 yellow, 5 blue)
	isPlayable := method (handDeck,
		handDeck first
	)
	playFromHand := method (hand,
		playing := isPlayable (hand)
		if (playing isNil,
			Error raise (type, "Can't satisfy this goal")
		)
		playing sortBy (
			block (a, b, a id > b id)
		)
		while (playing count > cards,
			playing pop
		)
		playing foreach (i, card,
			hand playCard (card)
		)
	)
)


CardList := List clone do (
	type := "CardList"
	position := method (id, 
		indexOf (detect (i, card, card id == id))
	)
	cardWithId := method (id,
		at (position (id))
	)
	deal := method (number, source,
		number repeatTimes (add (source draw))
	)
	selectSuit := method (desiredSuit,
		select (i, card, card suit == desiredSuit)
	)
	
)

SampleHand := CardList clone do (
	bySuit := method (
		cardsBySuit := List clone
		suits foreach (i, suit,
			cardsBySuit add (self select (j, card, card suit == suit))
		)
		cardsBySuit // with wilds duplicated
	)
	byRank := method (
		cardsByRank := list (Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil)
		self foreach (i, card,
			rankOfcard := card rank
			cardsOfRank := cardsByRank at (rankOfcard)
			if (cardsOfRank,
				cardsOfRank add (card),
				cardsByRank atPut (rankOfcard, list (card))
			)
		)
		cardsByRank
	)
	assert (add (4 red); add (6 green); count, 2)
	assert (add (4 red); bySuit at(0) count, 1)
	assert (add (3 green); byRank at(3) count, 1)
	assert (add (3 green); add (3 yellow) byRank at(3) count, 2)
)

List asHand := method (
	new := SampleHand clone
	new addList (self)
)


GoalCard sampleHand := method (
	example asHand
)


////////////////////////////////////////////////////////////////////////////////

Deck := List clone do (
	type := "Deck"
	discards := List clone
	init := method (
		self discards := List clone
	)
	draw := method (
		if (first isNil, 
			shuffleDiscards
		)
		card := self random
		remove (card)
		card
	)
	discard := method (card, 
		discards add (card)
	)
	shuffleDiscards := method (
		addList (discards)
		discards empty
	)

	assert (draw, Nil)
	assert (add (Card clone do (id = 5)); draw id, 5)
	assert (discard (Card clone do (id = 6)); draw id, 6)
)

playingDeck := Deck clone do (
	nextId := 0
	addNewCards := method (
		list (red, yellow, green, blue, wild) foreach (i, suit,
			newSuit := PlayingCard clone
			newSuit suit = suit
			list (0,1,2,3,4,5,6,7,8,9) foreach (j, rank,
				new := newSuit clone
				new id = nextId; nextId = nextId + 1
				new assert (rank, rank)
				add (new)
			)
		)
	)
	shuffleDiscards := method (
		if (discards first,
			resend,
			addNewCards
		)
	)

	addNewCards
	assert (at(0) id, 0)
	assert (at(1) id, 1)
	assert (at(0) asString, "0 red")
	assert (at(10) asString, "0 yellow")
	assert (at(11) asString, "1 yellow")
	assert (101 repeatTimes (draw); nextId, 150)
)


goalDeck := Deck clone
goalDeck addCard := method (card, 
	card assert (id, Nil)
	card id = goalDeck count
	add (card)
	card assert ((isPlayable (sampleHand)) isNil, Nil)
)
goalDeck addCardForEachSuit := method (cardProto,
	addCard (cardProto clone do (suit = red))
	addCard (cardProto clone do (suit = yellow))
	addCard (cardProto clone do (suit = green))
	addCard (cardProto clone do (suit = blue))
)


////////////////////////////////////////////////////////////////////////////////

FlushGoal := GoalCard clone do (
	points := method (
		cards * cards
	}
	isPlayable := method (hand,
		cardsOfSuit := hand select (i, card, card suit == self suit)
		if (cardsOfSuit count >= cards, cardsOfSuit, Nil)	
	)
	example := method (
		hand := list (2 red, 4 red, 5 red, 7 red, 8 red)
		while (hand count > cards, hand pop)
		hand foreach (i, card, card suit = self suit)
		hand
	)		
)

goalDeck do (
	addCardForEachSuit (FlushGoal clone do (cards = 3; goal = "three card flush"))
	addCardForEachSuit (FlushGoal clone do (cards = 4; goal = "four card flush"))
	assert (at (0) id, 0)
	assert (at (1) id, 1)
	assert (at (7) id, 7)
)

AnySuitFlushGoal := FlushGoal clone do (
	suit := AnyOneSuit
	points := method ((resend () / 2) floor)
	assert (cards = 5; points, 12)
	example := method (
		hand := list (2 red, 4 red, 5 red, 7 red, 8 red)
		while (hand count > cards, hand pop)
		hand
	)
	isPlayable := method (hand,
		cardsBySuit := hand bySuit
		cardsBySuit foreach (i, cardsOfSuit,
			if (cardsOfSuit count >= cards, return cardsOfSuit)
		)
		Nil
	)
)	

goalDeck do (
	addCard (AnySuitFlushGoal clone do (cards = 5; goal = "five card flush"))
	addCard (AnySuitFlushGoal clone do (cards = 4; goal = "four card flush"))
)

StraightGoal := GoalCard clone do (
	suit = MixedSuit
	cards = 3
	points = 5
	goal = "three card straight"
	example = list (5 red, 6 green, 7 yellow)

	isPlayable := method (hand,
		cardsToPlay := list ()
		hand byRank foreach (i, cardsOfRank,
			if (cardsOfRank,
				cardsToPlay add (cardsOfRank pop)
				if (cardsToPlay count == cards, return cardsToPlay),

				cardsToPlay empty
			)
		)
		Nil
	)
)

LongStraightGoal := StraightGoal clone do (
	cards = 4
	points = 10
	goal = "four card straight"
	example = list (5 red, 6 green, 7 yellow, 8 green)
)

StraightFlushGoal := StraightGoal clone do (
	points = 25
	goal := "3_card straight flush"
	example := method (suit changeAll (resend))

	isPlayable := method (hand,
		cardsToPlay := list ()
		cardsBySuit := hand bySuit
		cardsOfSuit := cardsBySuit at (suit id)
		if (cardsOfSuit count < cards, return Nil)
		cardsOfSuit asHand byRank foreach (i, cardsOfRank,
			if (cardsOfRank,
				cardsToPlay add (cardsOfRank pop)
				if (cardsToPlay count == cards, return cardsToPlay),

				cardsToPlay empty
			)
		)
		Nil
	)

)

AnySuitStraigthFlushGoal := StraightFlushGoal clone do (
	points = 15
	suit := AnyOneSuit

	isPlayable := method (hand,
		cardsBySuit := hand bySuit
		cardsBySuit foreach (ii, cardsOfSuit,
			if (cardsOfSuit count >= cards, 
				cardsToPlay := list ()
				cardsOfSuit asHand byRank foreach (i, cardsOfRank,
					if (cardsOfRank,
						cardsToPlay add (cardsOfRank pop)
						if (cardsToPlay count == cards, return cardsToPlay),

						cardsToPlay empty
					)
				)
			)
		)
		Nil
	)
)

goalDeck do (
	addCard (StraightGoal clone)
	addCard (LongStraightGoal clone)
	addCardForEachSuit (StraightFlushGoal)
	addCard (AnySuitStraigthFlushGoal clone)
)

		
KindGoal := GoalCard clone do (
	points = method ((cards * cards * cards / 2) floor)
	suit = MixedSuit
	example := method (
		hand := list (6 red, 6 yellow, 6 blue, 6 green)
		while (hand count > cards, hand pop)
		hand
	)
	isPlayable := method (hand,
		hand byRank foreach (i, cardsOfRank,
			if (cardsOfRank and cardsOfRank count >= cards, return cardsOfRank)
		)
		Nil
	)
)

goalDeck do (
	addCard (KindGoal clone do (cards = 2; goal = "_ pair _"))
	addCard (KindGoal clone do (cards = 3; goal = "three of_a kind"))
	addCard (KindGoal clone do (cards = 4; goal = "four of_a kind"))
)


////////////////////////////////////////////////////////////////////////////////


Goals := CardList clone do (
	type := "Goals"
	satisfy := method (id, hand,
		pos := position (id)
		at (pos) playFromHand (hand)
		hand pointsScored = hand pointsScored + (at (pos) points)
		at (pos) discard
		atPut (pos, goalDeck draw)
	)
)

ourGoals := Goals clone do (
	add (goalDeck draw)
	add (goalDeck draw)
	add (goalDeck draw)
	add (goalDeck draw)
	add (goalDeck draw)
)

assert (ourGoals at(4) type, "GoalCard")
assert (ourGoals detect (i, card, card id == ourGoals at(2) id) id, ourGoals at(2) id)
assert (ourGoals position (ourGoals at(2) id), 2)
assert (ourGoals at(3) type, "GoalCard")
assert (ourGoals at(3) id type, "Number")


Hand := SampleHand clone do (
	type := "Hand"
	cardsViewed := 5
	pointsScored := 0
	lastActivity := Date clone now

	pointsPerCard := method ((pointsScored  * 1000 / cardsViewed) floor / 1000)
	score := method (pointsScored .. " points averaging " .. pointsPerCard .. " points per card")
	inactiveDuration := method (Date clone now - lastActivity)

	init := method (
		add (playingDeck draw)
		add (playingDeck draw)
		add (playingDeck draw)
		add (playingDeck draw)
		add (playingDeck draw)
		self lastActivity := Date clone now
	)
	render := method (markup,
		markup row (
			block (
				for (i, 0, 4,
					at (i) render (markup)
					markup html (at (i) actionHtml)
				)
			)
		)
	)
	discard := method (id,
		pos := position (id)
		at (pos) discard
		atPut (pos, playingDeck draw)
		cardsViewed = cardsViewed + 1
	)
	playCard := method (card,
		discard (card id)
	)	
	throwIn := method (
		self foreach (i, card,
			if (card,
				card discard // without replacement
				atPut (i, Nil)
			)
		)
	)
	refreshHand := method (
		self foreach (i, card,
			if (card isNil,
				atPut (i, playingDeck draw)
				cardsViewed = cardsViewed + 1
			)
		)
	)
)


////////////////////////////////////////////////////////////////////////////////

Markup := Buffer clone do (

	html := method (string, self append (string))
	assert (html("foo"), "foo")

	row := method (block,
		html ("<br><br><table><tr>")
		block 
		html ("</table>\n")
	)
	section := method (label, body,
		html ("<tr><td valign=top align=right width=120><b>")
		append (label)
		html ("</b></font> <td valign=top>")
		append (body)
	)
	bar := method (average,
		width := ((average * 100) floor)
		html ("<br><br><table bgcolor=#dddddd height=20 width=" .. width .. "><tr><td> " .. average .. " </table>")
	)
	assert (bar (2.23456), "<br><br><table bgcolor=#dddddd height=20 width=223><tr><td> 2.23456 </table>")
)


////////////////////////////////////////////////////////////////////////////////

Turn := Object clone do (
	type = "Turn"
	query := Nil
	hand := Nil
	markup := Nil

	commands := list ("about", "play", "players", "docs", "community", "discard", "satisfy", "explain", "trace")
	doCommand := method (number, self doString (commands at(number)))

	renderGoalAction := method (goalCard,
		if (goalCard isPlayable (self hand), 
			markup html ("<br><a href=satisfy?" .. goalCard id .. ">play</a>"),
			markup html ("<br>&nbsp;")
		)
	)

	about := method (
		markup section (
			"about",
			"""IoGame is a small multi-user computer game inspired by the 
			card game <i>Target</i>. It's <a href=http://c2.com/~ward/io/IoGame>
			source</a> is open under the BSD license. See the
			<a href=trace>objects</a> in this server right now."""
		)
		markup section (
			"Andy Daniel", 
			"""Silicon Valley chip designer Andy Daniel invented Target. 
			Read about him <a href=http://www.gamepuzzles.com/andy.htm>here</a>. 
			Buy Target or other games by Andy from his company, 
			<a href=http://www.enginuity.com/>Enginuity</a>."""
		)
		markup section (
			"Ward Cunningham", 
			"""Oregon software developer Ward Cunningham created IoGame 
			as his entry in the first Io game contest. Ward plays Target or other 
			card games with his family at his local Brew Pub every weekend. Use this 
			Google <a href=http://www.google.com/search?q=Ward+Cunningham>search</a> 
			to learn lots more about Ward."""
		)
		markup section (
			"Steve Dekorte", 
			"""Bay Area developer Steve Dekorte invented the Io language, 
			launched the Io game contest and hosts the pages that IoGame mimics. 
			Visit his <a href=http://www.dekorte.com/>web page</a> or learn about his 
			<a href=http://www.iolanguage.com>Io language</a>."""
		)
	)

	play := method (
		markup section (
			"play",
			"""Earn points by satisfying goals. You can't loose, but others 
			can win faster. Play for speed, endurance or efficiency. """
		)
		markup html ("You have " .. hand score)
		markup section (
			"shared goals",
			"""Play these cards to score points before other 
			players do. We'll take the required cards from your hand and 
			draw new ones to replace them. Click <a href=play>refresh</a>
			to see if anyone else has played these cards."""
		)
		markup row (
			block (
				ourGoals for (i, 0, 4,
					ourGoals at (i) render (markup)
					renderGoalAction (ourGoals at (i))
				)
			)
		)
		markup section (
			"your hand", 
			"""Use these cards to complete goals. Discard cards you don't want 
			and we'll draw new cards to replace them."""
		)
		hand render (markup)
	)

	discard := method (
		hand discard (query)
		play
	)

	satisfy := method (
		ourGoals satisfy (query, hand)
		play
	)

	explain := method (
		goal := ourGoals cardWithId (query)
		markup section (
			"goal",
			goal goal replace ("_", " ")
		)
		markup section (
			"code",
			goal getSlot ("isPlayable") code replace ("\n", "<br>")
		)
		markup section (
			"example",
			""
		)
		markup html ("<table><tr>")
		goal example foreach (i, card,
			card render (markup)
		)
		markup html ("</table>\n")
		markup section (
			"stats",
			"This card earns " .. goal points .. " points, or " .. ((goal points)/(goal cards)) .. " points per card<br>"
		)
		n := 0
		100 repeatTimes (
			aHand := Hand clone do (
				add (playingDeck draw)
				add (playingDeck draw)
			)
			if (goal isPlayable (aHand),
				n = n + 1
			)
			aHand throwIn
			yield
		)
		markup html (n .. " out of 100 random seven-card hands (sans held cards) could play this goal")
	)

	players := method (
		markup section (
			"players",
			"""Play by yourself or with others. There are no turns. 
			Play as fast as you can to get the good goal cards. 
			These are the current scores for everyone who has 
			played since this ioServer was started. Hands idle for
			10 minutes are discarded to be replaced when the player
			returns."""
		)
		handsByIp foreach (i, hand,
			markup section (i, hand score .. ", idle " .. hand inactiveDuration asString)
			markup bar (hand pointsPerCard)
		)
	)

	docs := method (
		markup section (
			"contest",
			"""<a href=http://www.iolanguage.com/blog/blog.cgi?do=item&id=43>Announcement</a><br>
			<a href=http://groups.yahoo.com/group/iolanguage/message/4984>Thread</a>"""
		)
		markup section (
			"game",
			"""<a href=http://c2.com/~ward/io/IoGame/>Overview</a><br>
			<a href=http://c2.com/~ward/io/IoGame/iogame.io>Source Code</a>
			"""
		)
		markup section (
			"language",
			"""<a href=http://www.iolanguage.com/>Home Page<br>
			<a href=http://www.iolanguage.com/Source/release/Io/_docs/IoProgrammingGuide.html>
			Programming Guide</a><br>
			<a href=http://www.iolanguage.com/Source/release/Io/_docs/IoReferenceManual.html>
			Reference Manual</a>
			"""
		)
	)

	community := method (
		markup section (
			"community", 
			"""See <a href=http://c2.com/cgi/wiki?IoGame>Wiki</a> 
			for game schedules and high scores."""
		)
	)

	trace := method (
		markup html ("<pre><font color=gray>")
		Tracer clone trace ("", "Lobby", Lobby, markup)
	)

)

handsByIp := Map clone do (
	// would be better with login
	handAt := method (ip,
		if (hasKey(ip) isNil,
			atPut (ip, Hand clone)
		)
		at (ip)
	)
)

Turn clone do (
	hand = Hand clone
	markup = Markup clone
	assert (about; play; players; docs; community; "done", "done")
	assert (query = hand first id; discard; "done", "done")
	assert (query = ourGoals first id; explain; "done", "done")
	hand throwIn
	assert (playingDeck count + (playingDeck discards count), 50)
)


////////////////////////////////////////////////////////////////////////////////

Tracer := Map clone do (
	trace := method (pad, name, obj, markup,
		id := getSlot("obj") uniqueId asString
		kind := getSlot("obj") type
		slot := pad .. "<font color=black>" .. name .. "</font>: " .. kind
		if (kind == "CFunction", return)
		if (kind == "Block", return)
		if (kind == "Number", 
			markup html ("\t\t" .. slot .. " = " .. obj .. "\n"); 
			return
		)
		if (kind == "String" and obj length <= 40, 
			markup html ("\t\t" .. slot .. " = " .. obj escape replace ("<", "&lt;") .. "\n"); 
			return
		)

		if (hasKey (id), 
			markup html ("\t\t" .. slot .. " " .. at (id) .. "\n"),

			label := (count + 1) asString
			atPut (id, label)
			markup html ("\t" .. label .. "\t" .. slot .. "\n")
			if (getSlot("obj") isNil, return)
			if (name == "IoVM" or name == "IoServer" or name == "IoDesktop", return)
			getSlot("obj") slotNames sort foreach (i, v,
				if (v != "Nop",
					trace (pad .. "|   ", v, getSlot("obj") getSlot(v), markup)
				)
			)
			if (kind == "Deck" or kind == "List" or kind == "Map" or kind == "Hand",
				getSlot("obj") foreach (i, v,
					trace (pad .. "|   ", i, v, markup)
				)
			)			
		)
	)
)


////////////////////////////////////////////////////////////////////////////////

Server clone do (

	handler := Object clone do (
		handle := method (aSocket,
			// untrusted input does not leave this method
			if (aSocket isOpen and aSocket read, 
				aSocket write (header)
				markup := Markup clone
				request := aSocket readBuffer asString split("\n") at(0) split(" ")
				try (
					handsByIp foreach (i, hand,
						if ((hand inactiveDuration asNumber) > 600, hand throwIn)
					)
					aHand := handsByIp handAt (aSocket host)
					aHand refreshHand
					path := request at(1) split("/")
					if (path count == 0, path = list ("about"))
					parts := path first split("?")
					if (aNumber := Turn commands indexOf (parts at (0)),
						aTurn := Turn clone
						aTurn hand = aHand
						aTurn markup = markup
						aTurn query = parts at(1) ?asNumber
						aTurn doCommand (aNumber),

						Error raise (type, "can't do " .. parts at (0))
					)
					aHand lastActivity now
				) catch (Exception, e, 
					aSocket write (
						"<center><table bgcolor=#ffffcc cellpadding=10><tr><td><pre>", 
						e backTraceString replace ("<", "&lt;"), 
						"</pre></table></center>\n"
					)
					markup html ("</table></table>")
				)
				aSocket write (markup)
				aSocket write (footer)
				aSocket close
			)
	 	)

		header := """
			<html><head>
			<meta name="robots" content="noindex, nofollow">
			<title>IoGame</title>
			<style> a, body, td, table, tr { 
				font-size:14; 
				font-weight:normal; 
				font-family:"helvetice, arial, sans"; 
				text-decoration:none
			} </style></head>
			<body bgcolor="white" 
				text="#000" link="#666" vlink="#666" alink="#666" 
				leftmargin=0 rightmargin=0 marginwidth=0 marginheight=0>
			<br>
			<table cellpadding=0 cellspacing=0 border=0 width=100%><tr>
			<td align=left valign=bottom width=10>&nbsp;</td>
			<td align=left valign=bottom><a href="about">
				<font size=64 face=times color=black>IoGame</font>
				<br>a small computer game</a></td>
			<td valign=bottom align=right>
				<table cellpadding=0 cellspacing=0 border=0><tr>
				<td width=1 align=center><a href="about" >about</a> <td width=20>&nbsp;
				<td width=1 align=center><a href="play" >play</a> <td width=20>&nbsp;
				<td width=1 align=center><a href="players" >players</a> <td width=20>&nbsp;
				<td width=1 align=center><a href="docs" >docs</a> <td width=20>&nbsp;
				<td width=1 align=center><a href="community" >community</a> <td width=10>&nbsp;
				</table>
			<tr>
			<td colspan=6 height=1 bgcolor=#bbbbbb>
			</table>
			<table cellpadding=0 cellspacing=12 border=0>
			<br><br>
		"""

		footer := """
			</table>
		"""

	)

	setPort (8080)
	handleSocket := method (aSocket, handler clone @handle (aSocket))
	writeln ("start")
	start
)
