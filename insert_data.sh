#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Leemos el archivo games.csv y lo pasamos al bucle while
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # 1. Ignorar la primera línea (el encabezado)
  # Si la variable YEAR es distinta de la palabra "year"...
  if [[ $YEAR != "year" ]]
  then
    # 1. Obtener el team_id del equipo ganador
    # Completa el SELECT dentro de las comillas
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # 2. Si no se encontró el ID (la variable está vacía)
    if [[ -z $TEAM_ID ]]
    then
      # Insertar el equipo en la tabla teams
      # Completa el INSERT dentro de las comillas
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      
      # Es buena idea imprimir un mensaje para ir viendo el progreso en consola
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo "Insertado en teams: $WINNER"
      fi
    fi
  # 1. Obtener el team_id del equipo ganador
    # Completa el SELECT dentro de las comillas
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # 2. Si no se encontró el ID (la variable está vacía)
    if [[ -z $OPPONENT_ID ]]
    then
      # Insertar el equipo en la tabla teams
      # Completa el INSERT dentro de las comillas
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      
      # Es buena idea imprimir un mensaje para ir viendo el progreso en consola
      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then
        echo "Insertado en teams: $OPPONENT"
      fi
    fi
    # ====================================
    # 3. LÓGICA PARA INSERTAR EL PARTIDO
    # ====================================
    # Obtenemos los IDs definitivos (ahora estamos seguros de que existen en la BD)
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # Ahora insertamos todos los datos en la tabla games
    # Completa el INSERT asegurándote de usar las variables correctas
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
    
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo "Insertado en games: $YEAR, $ROUND"
    fi
  fi
done