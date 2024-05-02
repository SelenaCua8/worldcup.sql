#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_G OPPONENT_G
do
  echo "$YEAR, $ROUND, $WINNER"
  TEAMS=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
  if [[ ! -z $WINNER && $WINNER != "winner" && -z $TEAMS ]]
  then
    INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ "$INSERT_TEAM" == "INSERT 0 1" ]]
    then
      echo "Inserted into team, $WINNER"
    fi
  fi

  TEAMS2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
  if [[ ! -z $OPPONENT && $OPPONENT != "opponent" && -z $TEAMS2 ]]
  then
    INSERT_TEAM2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ "$INSERT_TEAM2" == "INSERT 0 1" ]]
    then
      echo "Inserted into team, $OPPONENT"
    fi
  fi

  TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  if [[ -n $TEAM_ID_W || -n $TEAM_ID_O ]]
  then
    if [[ $YEAR != "year" ]]
    then
      INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $TEAM_ID_W, $TEAM_ID_O, $WINNER_G, $OPPONENT_G)")
      if [[ "$INSERT_GAMES" == "INSERT 0 1" ]]
      then
        echo "Inserted into games, $YEAR"
      fi
    fi
  fi

done

