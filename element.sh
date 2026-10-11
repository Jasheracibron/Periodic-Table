#!/bin/bash

if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

if [[ ! $1 =~ ^[[:alnum:]]+$ ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

element=$(psql --username=freecodecamp --dbname=periodic_table --tuples-only --no-align --field-separator='|' -c "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p USING (atomic_number) JOIN types t USING (type_id) WHERE e.atomic_number::text = '$1' OR e.symbol = '$1' OR e.name = '$1';")

if [[ -z $element ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

IFS='|' read -r atomic_number name symbol type atomic_mass melting_point boiling_point <<< "$element"
printf "The element with atomic number %s is %s (%s). It's a %s, with a mass of %s amu. %s has a melting point of %s celsius and a boiling point of %s celsius.\n" \
  "$atomic_number" "$name" "$symbol" "$type" "$atomic_mass" "$name" "$melting_point" "$boiling_point"