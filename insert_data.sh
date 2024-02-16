#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
  echo "Test"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
  echo "Prod"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
   if [[ $YEAR != "year" ]]
then
  # get team id for WINNER
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'");

  # if not found
  if [[ -z $WINNER_ID ]]
  then
    $($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
    # WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE team='$WINNER'");
    
  fi

  # get team id for OPPONENT
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'");
  if [[ -z $OPPONENT_ID ]]
  then
    $($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
    # OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE team='$OPPONENT'");
  fi

  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'");
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'");
  eval "$PSQL \"INSERT INTO games(winner_id, opponent_id, winner_goals, opponent_goals, year, round) VALUES ('$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS', '$YEAR', '$ROUND')\""

 
fi
done




cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
