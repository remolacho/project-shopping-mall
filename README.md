# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
  - ruby-2.6.5

* System dependencies
  - devise jwt
  - swagger
  - algoliasearch-rails
  - ancestry
 
* Database initialization
  - crear aplication.yml basado en aplication.yml.example

* Configuration
  - application.yml asignar valor a esas variables
    * development:
        * DATABASE:
        * USERNAME:
        * PASSWORD:
        * DATABASE_TEST:
        * ALGOLIASEARCH_APPLICATION_ID:
        * ALGOLIASEARCH_API_KEY:
        * ALGOLIASEARCH_API_KEY_SEARCH:
        * ALGOLIA_PER_PAGE: "12"
        * PER_PAGE: "12"
        * ALGOLIA_LIMIT: "5000"
        * JWT_SECRET:
        * SECRET_API:
        * URL_GET_PAYMENT: 'url de la pasarela de pago'
        * CLIENT_ID_FREE_MARKET:
        * SECRET_FREE_MARKET:

     * test:
        * DATABASE:
        * USERNAME:
        * PASSWORD:
        * DATABASE_TEST:
        * JWT_SECRET:
        * SECRET_API:
        * ALGOLIA_PER_PAGE: "3"
        * PER_PAGE: "3"
        * ALGOLIASEARCH_APPLICATION_ID:
        * ALGOLIASEARCH_API_KEY:
        * ALGOLIASEARCH_API_KEY_SEARCH:
        * URL_GET_PAYMENT: 'url de la pasarela de pago'
  
  - bundle install
  
  - crear bd de test y correr migrate en env test 
 
* How to run the test suite
  - rails rswag:specs:swaggerize (correra los test y asu ves creara la documentacion)
  - rails g rspec:swagger namespace::controller_name
  - rspec
* Services (job queues, cache servers, search engines, etc.)
  - Algolia como motor de busqueda
  - swagger como doc para los EP
  
* Deployment instructions