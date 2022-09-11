# Fighter Planes
#### Video Demo: https://youtu.be/D4ClML7pg08
#### Description: It is a game in which you have to survive collisions with enemy planes and achieve the largest number of points by destroying them and passing many levels. also, you have 3 lives and on each level, the enemy's speed is increasing. if you have 0 lives the game will be ended and if you start the game again you will find that your high score is saved automatically. in the final project repository, there are many folders and files and I will explain each alone.


# files in the repository

- components
- objects
- src
- states
- confi.lua
- globals.lua
- lume.lua
- main.lua


## components folder
in this folder, I put the components that I will use in the other classes to make the implementation easier like Text, Button, and SFX (sound effects) classes. and I will explain each file below.
### Text.lua file :
- properties:
    - text: string - text to be displayed (required)
    - x: number - x position of text (required)
    - y: number - y position of text (required)
    - font_size: string (optional)
        default: "p"
        options: "h1"-"h6", "p"
    - fade_in: boolean - Should text fade in (optional)
        default: false
    - fade_out: boolean - Should text fade in (optional)
        default: false
    - wrap_width: number - Whe should text break (optional)
        default: love.graphics.getWidth() [window width]
    - align: string - Align text to location (optional)
    - opacity: number (optional)
        default: 1
        options: 0.1 - 1
        NB: Setting fade_in = true will overwrite this to 0.1

- functions:
    - setColor: to set the color of the text by setting the red, green, and blue components.
    - draw: it is the function that will draw the text on the screen and make the fade in and fade out and remove the text when it disappears from the table of texts.

### SFX.lua file :
- properties:
    - bgm : import the background music
    - effects table : import the effects that i will need in it
    - fx_played : boolean variable to check if is the effect played or not
- functions:
    - setFXPlayed: it is a function that takes one parameter which is boolean and put it in fx_played
    - playBGM: playing the background music
    - stopFX: function that take the effect name and stop it
    - playFX: function that take the effect name and the mode and play that effect
### Button.lua file :
- properties:
    - func: a function that will be executed when we press the button
    - text_color : the color of the text that will be it the button
    - button_color: the color of the button it self
    - width
    - height
    - text
    - text_align: it is the alignment of the text
    - font_size
    - button_x
    - button_y
    - text_x
    - text_y
    - text_component : it is a table in it we create a Text object and pass to it the properties of the Text class
- functions:
    - setButtonColor: setting the red, green, and blue components of the button's color
    - setTextColor:  setting the red, green, and blue components of the text's color
    - checkHover : a function that takes the mouse x position, y position, and the cursor radius to check if the user hovers on the button or not
    - click : takes the func property and executes it when the user clicks on the button
    - draw: draw the button, the text in the text_component, and reset the color to white
    - getPos: return x, y positions of the button
    - getTextPos: return x, y positions of the text

## objects folder
in this folder, I created the main objects that I will use in the project like player, enemy, and laser.and I will explain each file below.
### Enemy.lua file
 - properties
    - x
    - y
    - y_vel : which is the enemy speed
    - width : width of the rectangle i will draw around the plane to check collision
    - height : height of the rectangle i will draw around the plane to check collision
    - image : import the enemy plane image

 - functions
    - draw: a function to draw the rectangle around the enemy if we are in the debugging mode and draw the enemy image and disappears the enemy if we are in the pause window
    - move: a function to move the enemy down
    - exceedEdges : a function to check if the enemy exceed the down edge of the window
    - destroyEnemy : a function to destroy enemy and raise the score of the player and save the game after destroying the enemy by removing it from the enemies table and if the number of the enemies is equal zero this mean the player passed the level so we reset the enemies number


### Laser.lua file
 - properties
    - x
    - y
    - image: import the laser image
    - speed
    - width : width of the rectangle i will draw around the plane to check collision
    - height : height of the rectangle i will draw around the plane to check collision
    - distance : distance travelled by the laser
    - first_y: the y position of the laser when the player shoot it
    - exploading :  exploading: 0 = safe; 1 = exploading; 2 = done exploading
    - expload_time
    - EXPLODE_DUR

 - functions
    - move: a function to move the laser up and calculate the distance travelled
    - draw: a function to draw the laser and a rectangle around it in the debugging mode and also if the laser is exploading it will draw a shape of destroying laser by using circles
    - expload: a function to expload the laser and if the expload_time is greater than the EXPLODE_DUR then end the expload
### Player.lua file
 - properties
    - EXPLOAD_DUR
    - x : will be in the middle of the screen
    - y : will be in the bottom of the screen
    - image: import the player plane image
    - speed
    - width : width of the rectangle i will draw around the laser to check collision
    - height : height of the rectangle i will draw around the laser to check collision
    - radius : to use it to draw the destroying player with circles
    - lasers : table of lasers the player has
    - expload_time
    - exploading : boolean if ship exploading
    - MAX_LASERS
    - lives
    - live_image : import the image of small plane to be a sign for the lives

 - functions
    - drawLives : a function to draw the live_image on the top left of the screen
    - shoot : a function to shoot the laser by inserting a new index in lasers table and play the sound effect of the laser
    - exceedEdges : a function to check if the player exceed one of the 4 edges of the screen and prevent him
    - move : a function to move the player and use exceedEdges every time we move the player.and also move the laser that he shoot by using also the move function of the laser, expload the laser and destroy it
    - destroyLaser : takes an index and destroy the laser form the lasers table
    - draw : a function to draw the player if it is not exploading and else it draw circles that will be a sign to show the destroying player. also in debugging mode it will draw a rectangle around the player to check collision
    - expload : a function to expload the player and play the sound effect of the player explosion



## src folder
it is a folder containing the resources I used in the project like the sounds and the images of the player, enemy, and the background image


## states folder
it is a folder containing the states of the game like the menu and game file that will change our state and change the windows in the game

### Game.lua file
- properties
    - level: the level of the player now
    - state : table that containing all the states as boolean variables like menu, paused, running, and ended
    - score
    - high_score
    - screen_text : the texts that will appear on the screen
    - game_over_showing : boolean variable to check if the game ended and show the game over screen

- functions
    - changeGameState : a function that take a string and check if this string equal to any state and change the value of this state to true. and if the state is ended it will call the game over function
    - gameOver : a function that create a Text object with text property equal to "GAME OVER" and put it in the screen_text table . and also change the game_over_showing value to true.
    - draw : a function that take a boolean value as a parameter if it is true that mean draw paused text. also print the high_score and the score on the screen and if the game_over_showing is true it will draw game over with fade_in and fade_out and after that it will change Game State to menu
    - startNewGame: a function to check the lives of the player if it is less than 0 it will change Game State to ended. also it will print the level of the player on the screen and fill the enemies table with the enemies

### Menu.lua file
- properties
    - funcs : it is a table containing the function that will be executed when the user click on the buttons on the menu window
    - buttons : it is a table containing 2 buttons New Game button and Quit button

- functions
    - run : a function that take a boolean value and check if the user hovers on the button and change the button color. also call the function click of Button if the boolean is true
    - draw : a function to draw the 2 buttons


## Other files
### conf.lua file
it is a file containing the love.conf function that we put in it the configration settings like width, height of the game screen and the title of the game


### main.lua file
functions:
- reset : this function read the text file we saved our data in and deserialize the data to get our high_score. also in it we create sfx, player, game, and menu objects to restart or anything when game over
- love.load :a function that called once when we start the game . in it we call the function reset , make the mouse invisible , import the background image, call the function playBGM to play the background sound
- love.keypressed : function called when we press a key. i made some conditions it it .first, if the game state is running if the player press space call the function shoot , if the player press escape we change Game State to paused but if the game state is paused and the player press escape again then call the function change Game State to set the state to be running
- love.mousepressed : a function that call the function shoot if the player press the left click
- love.update : this is the function that run our game because it will be executed repeatedly. first get the position of the mouse. there is a condition if the game state is running then move the player and if the enemies number not 0 move also the enemies. if the player not exploading that mean we must calculate the distance between the player and the enemy that it is in the screen now if it is less than the height of the enemy (this height is the height of the rectangle i draw to check collision as i said) then this mean the enemy colide with the player so we expload the player and destroy the enemy and then if the expload_time is equal to 0 this mean we should decrease the lives by one and create a new player with the new number of lives after that if the lives is equal to 0 we changeGameState to ended and also we move the lasers in this function and calculateDistance between the laser and enemy as we made with the player and if the laser colide with enemy we destroy the laser and the enemy. if the enemy_num is equal to 0 this mean the player destroyed all the enemies in this level so we increase the levels by one and start new game. but if the game state is menu we run the menu and reset the game and if the game state is ended we change the resetcomplete to false to make a reset again if we press on new game.
- love.draw : in it i draw my background image i imported. also i made some conditions if game state is running or paused the game must draw the player , lives , and draw the paused screen in game object but if the state is menu draw the menu object and if the state is ended draw the game object . also if the game state not running then we draw cursor and finally print the frames per seconds


### globals.lua file
it is a file i put in it the global variables and functions

properties:
 - show_debugging: which is a boolean value we use to check if we want to draw a rectangle around to objects
 - enemy_num: the number of the enemies that will change from level to another level
functions:
 - calculateDistance : a function that takes the coordinates of two points and calculate the distance between them
 - saveGame : a function that use serialize function from lume library and create a text file containing the data we want to save it on the local project

### lume.lua file
A collection of functions for Lua, geared towards game development.this library helped me to save the high_score when we close the game.
