# README

Things you may want to cover:

* Ruby version
  2.4.5
* Serve the api
  docker-compose up
* Database initialization
  docker-compose exec web rake db:migrate
* How to run the test suite
  docker-compose exec web bundle exec rspec

* Create the first user on rails console or post the users folder, it's the only public route besides authenticate route.
  User.create name: 'name', password: 'secret', email: 'name@email.com'
  Then authenticate with these credentials and use the api
