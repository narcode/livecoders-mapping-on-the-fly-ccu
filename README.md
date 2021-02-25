# On-the-fly live coding mapping survey

 ## [on-the-fly project website](https://onthefly.space/)

 on-the-fly is a project to promote Live Coding practice, a performative technique focused on writing algorithms in real-time so that the one who writes is part of the algorithm. Live coding is mainly used to produce music or images but it extends beyond that. Our objectives are: supporting knowledge exchange between communities, engaging with critical reflections, promoting free and open source tools and approaching live coding to new audiences. The project runs from 10/2020 to 09/2022, is co-founded by the Creative Europe program, and is led by Hangar in collaboration with ZKM | Center for Art and Media Karlsruhe, Ljudmila and Creative Coding Utrecht.

This project is possible thanks to
 
 <img src='public/CCE.png' width=180>

 <img src='public/logo_sci.gif' width=80>

This project is bootstrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app).

## requirements
Make a python venv and install the following:

- mysql (for the database)
- aiohttp & gunicorn (for the server)
- aiohttp_middlewares
- aiomysql & sqlalchemy (to communicatie with the database)

## inititlization values

You will need to create a .env file in the root of the project with the following variables:
ELM_APP_DEV_URL
ELM_APP_PROD_URL

# start the backend server
`gunicorn server:app --bind localhost:8080`

