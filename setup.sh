docker-compose up --force-recreate -d iris

until MSYS_NO_PATHCONV=1 docker-compose exec iris iris session IRIS -U %SYS "write ""ready"",!" >/dev/null 2>&1; do
  echo "Waiting for IRIS..."
  sleep 2
done

MSYS_NO_PATHCONV=1 docker-compose exec --user root iris /home/irisowner/intro-to-iris-instruqt/01-untitled-challenge-wbobj4/setup-iris
MSYS_NO_PATHCONV=1 docker-compose exec --user root iris /home/irisowner/intro-to-iris-instruqt/04-untitled-challenge-5q6n6x/setup-iris
