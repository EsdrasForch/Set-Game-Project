# Set Game Project
- CMP 430 - Final Project

# Simulator View
![alt text](https://user-images.githubusercontent.com/63530619/148418662-f94cc3ca-544b-4085-b547-71e5db72909d.png)

# Tasks - Part 1
- Implement a game of solo (i.e. one player) Set.

- As the game play progresses, try to keep all the cards visible and as large as possible. In other words, cards should get smaller (or larger) as more (or fewer) appear onscreen at the same time. It's okay if you want to enforce a minimum size for your cards and then revert to scrolling when there are a very large number of cards. Whatever way you deal with "lots of cards" on screen, it must always still be possible to play the game (i.e. cards must always be recognizable, even when all 81 are in play at the same time).

- Cards can have any aspect ratio you like, but they must all have the same aspect ratio at all times (no matter their size and no matter how many are on screen at the same time). In other words, cards can be appearing to the user to get larger and smaller as the game goes on, but the cards cannot be "stretching" into different aspect ratios as the game is played.

- The symbols on cards should be proportional to the size of the card (i.e. large cards should have large symbols and smaller cards should have smaller symbols).

- Users must be able to select up to 3 cards by touching on them in an attempt to make a Set (i.e. 3 cards which match, per the rules of Set). It must be clearly visible to the user which cards have been selected so far.

- After 3 cards have been selected, you must indicate whether those 3 cards are a match or mismatch. You can show this any way you want (colors, borders, backgrounds, whatever). Anytime there are 3 cards currently selected, it must be clear to the user whether they are a match or not (and the cards involved in a non-matching trio must look different than the cards look when there are only 1 or 2 cards in the selection).

- Support "deselection" by touching already-selected cards (but only if there are 1 or 2 cards (not 3) currently selected).

- When any card is touched on and there are already 3 matching Set cards selected, then ... 


-      As per the rules of Set, replace those 3 matching Set cards with new ones from the deck

-      If the deck is empty then the space vacated by the matched cards (which cannot be replaced since there are no more cards) should be made available to the remaining cards (i.e. which may well then get bigger)

-      If the touched card was not part of the matching Set, then select that card

-      If the touched card was part of a matching Set, then select no card

- When any card is touched and there are already 3 non-matching Set cards selected, deselect those 3 non-matching cards and select the touched-on card (whether or not it was part of the non-matching trio of cards).

- You will need to have a "Deal 3 More Cards" button (per the rules of Set). 

     when it is touched, replace the selected cards if the selected cards make a Set

     or, if the selected cards do not make a Set (or if there are fewer than 3 cards selected, including none), add 3 new cards to join the ones already on screen (and do not affect the selection)

     disable this button if the deck is empty

- You also must have a "New Game" button that starts a new game (i.e. back to 12 randomly chosen cards).

- To make your life a bit easier, you can replace the "squiggle" appearance in the Set game with a rectangle.

- You must author your own Shape struct to do the diamond.

- Another life-easing change is that you can use a semi-transparent color to represent the "striped" shading. Be sure to pick a transparency level that is clearly distinguishable from "solid".

- You can use any 3 colors as long as they are clearly distinguishable from each other.

- You must use an enum as a meaningful part of your solution.

- You must use a closure (i.e. a function as an argument) as a meaningful part of your solution.

- Your UI should work in portrait or landscape on any iOS device. This probably will not require any work on your part (that's part of the power of SwiftUI), but be sure to experiment with running on different simulators/Previews in Xcode to be sure.

# Tasks - Part 2
- Draw the actual shapes: Squiggle, Diamond, and Oval. You may use the code that was demonstrated in class for drawing the Squiggle to get you started with this.

- Use the actual shadings: Outlined, Striped, and Filled. You may use the code that was demonstrated in class for drawing the Squiggle .

- All the cards that are in play must be visible on the screen. No scrolling should be necessary.

- You Will add persistence to your game. This must include the following: 

-      The first time the game is played, no state is restored, the game starts as usual.

-       You will autosave the state of your SetGame as changes are made to the cards that are in play, the score, and the remaining cards in the SetCardDeck.

-      All subsequent times, after the first time, that the game is played; you will restore the state of the SetGame and SetCardDeck from your autosaved data.

-      You are free to choose the method of autosaving. You can either use FileManager or UserDefaults. Both techiniques were demonstrated in EmojiArt.

- Your user interface will show how many cards are remaining in the SetCardDeck.

- When the user asks for 3 more cards and the the SetCardDeck is empty, you will show the user an alert View telling them that the SetCardDeck is empty. The user will have an "OK" button to dismiss the alert and continue playing the game. After displaying the alert, the "Deal 3 More Cards" button must be disabled.

- Your solution must work and look good in both Portrait and Landscape mode.
