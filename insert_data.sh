#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi




# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL"TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 

   if [[ $OPPONENT != "opponent" ]]
      then 
      TEAM_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$WINNER'")
      echo $TEAM_ID

      if [[ -z $TEAM_ID ]]
         then  INSERT_TEAM_RESULT=$($PSQL"INSERT INTO teams(name) VALUES('$WINNER')")

         if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
           then echo 'INSERTED'
         fi

         TEAM_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$WINNER'")

      fi   
   fi

    if [[ $WINNER != "winner" ]]
      then 
      TEAM_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$OPPONENT'")
      echo $TEAM_ID

      if [[ -z $TEAM_ID ]]
         then  INSERT_TEAM_RESULT=$($PSQL"INSERT INTO teams(name) VALUES('$OPPONENT')")

         if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
           then echo 'INSERTED'
         fi

         TEAM_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$OPPONENT'")

      fi   
   fi




   if [[ $YEAR != 'year' ]] 
      then 
              WINNER_ID=$($PSQL"SELECT team_id from TEAMS where name='$WINNER'")
              OPPONENT_ID=$($PSQL"SELECT team_id from TEAMS where name='$OPPONENT'")

              INSERT_YEAR_RESULT=$($PSQL"INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
               VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

               if [[ $INSERT_YEAR_RESULT == 'INSERT 0 1' ]]
                  then echo "inserted into games $YEAR '$ROUND' $WINNER_ID $OPPONENT_ID $WINNER_GOALS $OPPONENT_GOALS"
               fi   
   fi   
done
