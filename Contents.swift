//: Playground - noun: a place where people can play

import UIKit
import XCPlayground


var str = "Begining iOS Programming Final Project: Team Randomizer.\nDate: 11/8/15\nBy: Felix (Nestor) Sotres\n\nTeam Randomizer will take a number of players and split them into the number of teams chosen by the 'user' (as it will really be someone altering the code). \n\nSince we cannot have input into Playgrounds, the User will have to adjust three variables, numberOfPlaeyers, numberOfTeams, & teamMode (First variables located in the Control Class). Depending on how many players and how many teams the user wants to create, team randomizer will take the number of players (from a preconfigured name list) and split them up into teams. The teamMode is to indicate if the user wants to use a Player's Rating (skill level) or just randomly assign players to teams (no rating).\n\nCONTROLS:\n\nnumberOfPlayers \t: Number of players you would like to create and split into teams (max: 20)\numberOfTeams \t: Number of teams you would like to split the players into (max: 20)\nteamMode \t\t: 0 = Fair teams (Using Player Rating [skill level]) 1 = Random (no rating).\n\n"
println(str)

//Control class handles control flow of program
class Control{
    //**** "Main Controls" for program ****/
    var numberOfPlayers = 8             //number of players to create (max: 20)
    var numberOfTeams = 2                //number of teams to create (max : 20)
    var teamMode = 0                     //0 = Fair teams with player rating 1 = Random assigned teams (no rating)
    //************************************/
    
    //create objects for MVC paradigm
    var theModel = Model()
    var theView = View()
    var run2Delay = 10.0      //delay for control to run 2nd part of program (after player creation)
    
    //main program function
    func run()-> Void{
        //set team creation mode 0 = Fair teams with player rating 1 = Randomly assigned teams (no rating)
        theModel.setCreationMode(teamMode)
        //based on team creation mode set the delay for the program to run (run a bit faster)
        if(teamMode == 1){
            run2Delay = 2   //run program a little faster if on Random assigned teams (no rating)
        }
        theView.printToUser("You have chosen \(numberOfPlayers) players to split into \(numberOfTeams) teams.")
        theModel.createPlayers(numberOfPlayers)
        theModel.delay(run2Delay){
            self.run2()
        }
    }
    
    //this function is used to regain program control after all delays
    func run2()-> Void{
        
        //print out all the players created (testing)
        //theView.printPlayerArray(theModel.getPlayerArray())
        println("Creating teams, one moment please...")
        //create teams
        theModel.createTeams(numberOfTeams, nPlayers: numberOfPlayers)
        theView.printTeamArray(theModel.getTeamArray(), mode: teamMode)
        
    }
    
    
}//end Control Class

//Model handles all data manipulation
class Model{
    //Class global variables
    
    //Date objects in order to get system time/date
    let date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    //array holding all possible players for demo
    var playerNames : [String] = ["Paco", "Emily", "Priya", "Angela", "Bryan", "Danny", "April", "Feihong", "Alex", "Reggie", "Katy", "Adam", "Pablo", "Felix", "Bill", "Devin", "Kyle", "Darrell", "Marco", "Cassie"]
    var teamCreationMode : Int = 0                  //0 = Fair teams using player rating 1 = Randomly assigned teams
    var playerArray : [Player] = [Player]()         //array of player objects
    var teamArray : [Team] = [Team]()               //array of team objects
    var delayValue : Double = 0.0                   //holds delay value
    var rate = 0
    
    //construction method for Model
    init(){
        //null
    }
    
    func setCreationMode(mode : Int)->Void{
        teamCreationMode = mode
    }
    
    func identify() -> Void{
        println("Im the Model!")
        
    }
    
    //delays execution on a closure (basically a timer delay)
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
        
    }
    
    //generates a random number based off the time
    func randomNumber() -> Int{
        //get current seconds
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: date)
        let seconds = components.second
        
        //create seed for random number
        var seed: UInt32 = UInt32(seconds)
        //get random number based off seed (current minute)
        var randomNumber = arc4random_uniform(seed)
        return Int(randomNumber)
    }
    
    //generates a random number from 0 to a value given
    func randomNumberRange(max: Int)->Int{
        //get random number based off seed (current minute)
        var randomNumber = arc4random_uniform(UInt32(max))
        return Int(randomNumber)
    }
    
    //generates a player rating value (how good they are) between 1 - 5
    func ratingValue()-> Int {
        var val = randomNumber()        //get a random number & temporarily store it
        //println("ratingValue() Random Number: \(val)") //testing
        
        //figure out a rating value between 1-5
        if (val < 10){
            return 1
        } else if (val > 9 && val < 33){
            return 3
        } else if (val > 32 && val < 40){
            return 5
        } else if (val > 39 && val < 50){
            return 2
        } else if (val > 49 && val < 61){
            return 4
        }else {
            return 1
        }
    }
    
    //creates players for game
    func createPlayers(numPlayers : Int)->Void{
        
        println("\nCreating \(numPlayers) players one moment please...")
        //create players
        
        /*Since we cant input values into Playgrounds, we will be using numPlayers as a simple control to make the necessary number of players*/
        
        //Check to see if number of players user wants to create is within max number for demo
        if( numPlayers <= playerNames.count){
            for(var pCnt = 0; pCnt < numPlayers; ++pCnt){
                
                //Check which team creation mode was selected
                if(teamCreationMode == 0){
                    //0 = Fair teams using player rating
                    //delay is used so creating players arent so close in stats (dependent on secs)
                    delayValue = Double(ratingValue())
                }else if (teamCreationMode == 1){
                    //no delay is used as teams will just be randomly assigned
                    delayValue = 1.0
                }else{
                    //any other value is not recognized and program exits
                    println("Team Creation Mode chosen is not recognized.\nPlease check entry and try again.\n")
                    return
                }
                
                
                //store some values in local variables to avoid complications with delay function
                var tempPlayerName = playerNames[pCnt]
                var tempCount = pCnt
                //testing
                //println("pCount: \(tempCount) Name: \(tempPlayerName) Delay: \(delayValue)")
                //create player on after a delay
                delay(delayValue){
                    //do nothing
                    //println("Delay* \(tempCount)")      //testing (tells me which delay value has executed)
                    
                    //Check which team creation mode was selected
                    if(self.teamCreationMode == 0){
                        //0 = Fair teams using player rating
                        //Create player (with attributes) and add to player array
                        self.playerArray.append( Player(name1: tempPlayerName , rating1: self.ratingValue()))
                    }else if(self.teamCreationMode == 1){
                        //1 = Randomly assigned teams (no rating)
                        //Create player (with attributes) and add to player array
                        self.playerArray.append( Player(name1: tempPlayerName , rating1: 1))
                    }else{
                        //any other value is not recognized and program exits
                        println("Team Creation Mode chosen is not recognized.\nPlease check entry and try again.\n")
                        return
                    }
                    
                    
                }
            }
        }else{
            //if players to create are more than those stored in the demo, display error message
            println("The number of players to create is larger than this demo can create. Please enter a lower number and try again. Thank you.")
            //do not proceed further return from function
            return
        }
        
        
        
        
        XCPSetExecutionShouldContinueIndefinitely() //force playground to pause to let asychronous work to finish
        
    }
    
    //returns the player array
    func getPlayerArray()-> [Player]{
        return playerArray
    }
    
    //figures out how many players will fit evenly in each team & creates team objects
    func createTeamObjects(numTeams: Int, numPlayers: Int)->Void{
        
        //Calculate how many players will fit evenly in a team
        var playersFitEvenly = numPlayers / numTeams
        //println("Players: \(numPlayers) / Teams: \(numTeams) = \(playersFitEvenly)")//testing
        
        for var cnt = 1; cnt <= numTeams; ++cnt{
            teamArray.append(Team(tNumber: cnt, fitEvenly: playersFitEvenly))
        }
    }
    
    //places player into team randomly
    func randomlyPlacePlayerIntoTeam(plyr : Player, numTeams : Int)->Int{
        //get a random team number
        var tempTeamNumber = randomNumberRange(numTeams)
        //get current number of players in this team
        var currentTeamNumberOfPlayers = teamArray[tempTeamNumber].getCurrentNumberOfPlayers();
        
        if(currentTeamNumberOfPlayers < teamArray[tempTeamNumber].getNumberOfPlayersThatFitEvenly()){
            teamArray[tempTeamNumber].addPlayerToTeam(plyr)
            return 0
        }else{
            return -1
        }
    }
    
    //finds a team that still has an empty player slot to fill
    func addToTeamWithOpenSlot(plyr : Player)->Int{
        //println("Finding a team with an open slot")//testing
        for team in teamArray{
            
            //find a team with an open slot and add player to that team
            if(team.getCurrentNumberOfPlayers() < team.getNumberOfPlayersThatFitEvenly()){
                team.addPlayerToTeam(plyr)
                return 0   //found a team, break current loop
            }
        }
        //no teams with empty slots left
        return -1
    }
    
    //makes necessary calls for each team to calculate their current skill level
    func calculateAllTeamsSkillLevels()->Void{
        for team in teamArray{
            team.calculateTeamsSkillLevel()
        }
    }
    
    //finds the team with the lowest skill rating
    func findTeamWithLowestSkill()->Team{
        //get the first team in the array
        var teamLowRating = teamArray[0]
        for(var cnt = 1; cnt < teamArray.count; ++cnt){
            //testing
            //println("Current Lowest Team: \(teamLowRating.getTeamNumber()) Skill: \(teamLowRating.getTeamsTotalSkill()) Comparing to: \(teamArray[cnt].getTeamNumber()) Skill: \(teamArray[cnt].getTeamsTotalSkill())")
            if(teamArray[cnt].getTeamsTotalSkill() < teamLowRating.getTeamsTotalSkill()){
                
                teamLowRating = teamArray[cnt]
                //println("Found NEW lowest rated Team: \(teamLowRating.getTeamNumber())") //testing
            }
        }
        return teamLowRating
    }
    
    //finds the team with the lowest skill rating (sum of player's skill rating) and adds player to team with lowest skill level
    func addPlayerToLowestSkillTeam(currPlayer : Player)->Void{
        //calculate all team's skill levels
        calculateAllTeamsSkillLevels()
        var lowestRatedTeam = findTeamWithLowestSkill()
        lowestRatedTeam.addPlayerToTeam(currPlayer)
    }
    
    //creates array of teams
    func createTeams( nTeams : Int, nPlayers : Int){
        
        //Create team objects
        createTeamObjects(nTeams, numPlayers: nPlayers)
        //Place players into random teams
        for(var cnt = 0; cnt < nPlayers; ++cnt){
            var currentPlayer = playerArray[cnt]
            //Try to add player to a team with empty slots
            if(randomlyPlacePlayerIntoTeam(currentPlayer, numTeams: nTeams) < 0){
                //if the random team has no empty slots, try to find one with an open slot
                if(addToTeamWithOpenSlot(currentPlayer) < 0){
                    addPlayerToLowestSkillTeam(currentPlayer)
                }
            }
            
        }
        
    }
    
    //returns the team array
    func getTeamArray()-> [Team]{
        return teamArray
    }
    
}//end Model Class



//View handles all GUI elements
class View{
    init(){
        //null
    }
    
    func identify() -> Void{
        println("Im the View!")
    }
    
    func printToUser(message : String)-> Void{
        println(message)
    }
    
    func printPlayerArray(pArray : [Player])-> Void{
        for player in pArray{
            printToUser("Player Name: \(player.name)")
            printToUser("Player Rating: \(player.rating)")
            printToUser("Team: \(player.team)")
        }
    }
    
    func printTeamArray(tArray : [Team], mode : Int) -> Void {
        for team in tArray{
            //check which creation mode was selected
            if(mode == 0){
                //0 = Fair teams using player rating
                //calculate team ratings again
                team.calculateTeamsSkillLevel()
                //print team info
                printToUser("\nTeam: \(team.teamNumber) Team Skill Rating: \(team.getTeamsTotalSkill())")
                var totalPlayers = team.getPlayerArray()
                //print player info
                for player in totalPlayers{
                    printToUser("\(player.name) rating: \(player.rating)")
                }
            }else if(mode == 1){
                //1 = Random assigned teams (no rating)
                //print team info
                printToUser("\nTeam: \(team.teamNumber)")
                var totalPlayers = team.getPlayerArray()
                //print player info
                for player in totalPlayers{
                    printToUser("\(player.name)")
                }
            }else{
                //incorrect mode selected. Error message and program ends
                printToUser("Team Creation Mode chosen is not recognized.\nPlease check entry and try again.\n")
                return
            }
            
            
        }
    }
    
}//end View Class

//Player class to create players & their stats for the app
class Player{
    //Player class variables/attributes
    var name : String = ""              //holds a players name
    var rating : Int = 0                //players rating level (how good they are)
    var team : Int = 0                  //players team number
    
    //initializing method (player does not start on a team
    init( name1 : String, rating1 : Int){
        self.name = name1
        self.rating = rating1
    }
    
    //initializing method (player starts on a team
    init( name1 : String, rating1 : Int, team1 : Int){
        self.name = name1
        self.rating = rating1
        self.team = team1
    }
    
}//end Player class

//Team class holds team info
class Team{
    //Team class variables
    //var name: String = ""                         //team name
    private var teamNumber : Int = 0                //team number
    private var numberOfPlayers: Int = 0            //number of players in team
    private var playersFittingEvenly: Int = 0       //number of players fitting evenly in this team
    private var teamSkill : Int = 0                 //teams total skill (sum of player's skill)
    var teamPlayerArray : [Player] = [Player]()     //holds players in this team
    
    init(tNumber : Int, fitEvenly : Int){
        //do nothing
        self.teamNumber = tNumber               //set team number
        self.playersFittingEvenly = fitEvenly   //set number of players that fit evenly in team
    }
    
    //getter methods
    
    func getTeamNumber()-> Int{
        return teamNumber
    }
    
    func getCurrentNumberOfPlayers()->Int{
        return numberOfPlayers
    }
    
    func getNumberOfPlayersThatFitEvenly()->Int{
        return playersFittingEvenly
    }
    
    func getPlayerArray()->[Player]{
        return teamPlayerArray
    }
    
    func getTeamsTotalSkill()->Int{
        return teamSkill
    }
    
    //increases current number of players in this team
    func increasePlayerCount(){
        numberOfPlayers += 1
    }
    
    //adds player to the Player array
    func addPlayerToTeam(player : Player)->Void{
        //add player to player array
        teamPlayerArray.append(player)
        //increase the number of players in this team
        increasePlayerCount()
    }
    
    //calculates teams total skill level by adding individual players skill level
    func calculateTeamsSkillLevel()->Void{
        if(!teamPlayerArray.isEmpty){
            //reset team skill level
            teamSkill = 0
            //recalculate team skill level
            for player in teamPlayerArray{
                teamSkill += player.rating
            }
        }
    }
}

var runProgram = Control()
runProgram.run()
























