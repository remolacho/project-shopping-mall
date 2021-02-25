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
        * EMAIL_FROM:
        * EMAIL_PASSWORD:
        * EMAIL_TO:
        * EMAIL_PROVIDER: 'smtp.gmail.com'
        * EMAIL_PORT: 587
        * EMAIL_DOMAIN: 'localhost'
        * ACCESS_TOKEN_PAYMENT: token de mercado pago
        * REDIS_URL: redis://127.0.0.1:6379/0
        * APP_SESSION_KEY: test123
        * TIMEOUT_REDIS: 3.minutes
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
        * EMAIL_FROM:
        * EMAIL_PASSWORD:
        * EMAIL_TO:
        * EMAIL_PROVIDER: 'smtp.gmail.com'
        * EMAIL_PORT: 587
        * EMAIL_DOMAIN: 'localhost'
        * SEND_EMAIL: true/false si desea enviar mails en los test en TRUE puede hacer los test mas lentos
        
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
  - para probar los correos o diseños pueden activar la variable SEND_EMAIL
  en el application.yml del lado test
  - luego correr en la consola rspec ./spec/controllers/v1/orders/payment_controller_spec.rb
  con esto les llegara al destino que colocaron en la variable EMAIL_TO
   
 