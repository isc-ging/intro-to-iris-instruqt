docker-compose up --force-recreate -d iris

until MSYS_NO_PATHCONV=1 docker-compose exec iris iris session IRIS -U %SYS "write ""ready"",!" >/dev/null 2>&1; do
  echo "Waiting for IRIS..."
  sleep 2
done

MSYS_NO_PATHCONV=1 docker-compose exec --user root iris /home/irisowner/intro-to-iris-instruqt/01-challenge-1/setup-iris
MSYS_NO_PATHCONV=1 docker-compose exec --user root iris /home/irisowner/intro-to-iris-instruqt/02-challenge-2/setup-iris
MSYS_NO_PATHCONV=1 docker-compose exec --user root iris /home/irisowner/intro-to-iris-instruqt/02-challenge-2/solve-iris

MSYS_NO_PATHCONV=1 docker-compose exec --user root iris /home/irisowner/intro-to-iris-instruqt/04-challenge-4/setup-iris
MSYS_NO_PATHCONV=1 docker-compose exec --user root iris /home/irisowner/intro-to-iris-instruqt/05-challenge-5/setup-iris


# MSYS_NO_PATHCONV=1 docker-compose exec --user root iris /home/irisowner/intro-to-iris-instruqt/04-untitled-challenge-5q6n6x/setup-iris
