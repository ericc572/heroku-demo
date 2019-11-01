# Happy Trails Campground: Heroku Ecosystem Dreamforce Demo 2019 Edition
## Introduction:

To demonstrate the power of Heroku Add-ons, in our Dreamforce session titled “*Customizing your app with Heroku Add-ons*”, we show how easily you can provision/extend the functionality of your Heroku web application using a variety of addons.

### URL: http://typeform-dreamforce.herokuapp.com (http://typeform-dreamforce.herokuapp.com/)


## 💻  Requirements

* Heroku
    * CLI or Dashboard
* Git
* Ruby 2.6 or later


## ➡️ Deploy to Heroku Button 💥
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)


## Flow

1. User submits form with the following information:
    1. Name
    2. Email
    3. SMS Opt-in (Yes/No)
    4. Phone No
    5. Additional Feedback
2. Typeform survey receives this, and sends a webhook notification to my Rails application
3. a). Heroku Connect creates a new contact record in Salesforce.

   b). Till sends an SMS to given phone number
2. User responds to Till SMS
3. User response is sent to Einstein Language to analyze sentiment using community model.
4. Percentage positivity is returned, and corresponding contact record in Salesforce is updated.
## *🔍 Add-on Services*
Attached Add-ons:
![Dashboard Screenshot:](/dashboard_addons.png?raw=true "Attached Addons: ")

## Technical Architecture
![Architectural Diagram:](/technical_diagram.png?raw=true)


### Einstein Vision/Language 👓

_*Description*_:
The Einstein Vision/Language add-on allows you to leverage AI in your application by making image recognition and natural language processing (NLP) easily accessible. You can train deep learning models or use predefined models using a REST API, as long as an API access token is obtained. It is compatible with any programming language.

*_Use case:_*
Here, I use Einstein NLP’s community based sentiment to analyze the sentiment of the customer’s text message response without having to build my own model using this endpoint: https://metamind.readme.io/docs/use-pre-built-models-sentiment

This responds with positive/negative/neutral probabilities of the given input.

### Heroku Connect (First Party!) 🔌

_*Description*_:
This add-on allows you to bi-directional sync between Salesforce and your Heroku application. Unify and/or share data in your Postgres database with the contacts, accounts and other custom objects in the Salesforce database.

*_Use case:_*
In this instance, Heroku Connect is used to write captured data from my typeform survey into a contact record within Salesforce, as well updating the corresponding record once the sentiment is analyzed from the text response.


### Heroku Postgres (first party!)

_*Description*_:
Our most popular add-on to date, Heroku Postgres provides a seamless approach of a managed data service in tandem to building your applications using PostgreSQL, one of the world’s most popular and powerful relational databases.

*_Use case:_*
Use Heroku Postgres to store and persist data records. Must be used for Heroku Connect to fully work. It creates a table in PG which syncs to Salesforce.

### Heroku Redis (First party!)

_*Description*_:
Heroku Redis is an in-memory key-value data store, run by Heroku, that is provisioned and managed as an add-on (https://elements.heroku.com/addons/heroku-redis).

*_Use case:_*
Used to process and schedule background jobs like delegating to Till, and  in a queue system.

### PaperTrail

_*Description*_:
Papertrail (https://elements.heroku.com/addons/papertrail) is an add-on (https://elements.heroku.com/addons) providing hosted log aggregation and management, including real-time tail, search, and alerts on application and platform logs.

*_Use case:_*
Use papertrail to check and tail (follow) live logs from my application, and monitoring events that are received/sent to help debug issues.

### Till

_*Description*_:
The till add-on is a way to ask questions via SMS and receive validated responses via webhook, enabling instant alerts, flash surveys, and real-time two-way communication with a simple HTTP API.

*_Use case:_*
Once customer survey response is sent, use Till to deliver an SMS question to the given phone #. Then, we subscribe to the event (webhook) with the user’s SMS response.


## Glossary/Links
- queue: A First in, first out collection mechanism for ordering items. Used here to schedule background jobs aka processes
- webhook: A way to schedule event notifications to another API in real time.
- Heroku Ecosystem: Our Elements Marketplace allow you to extend functionality of your app by attaching 200+ easy to use, preconfigured addons: https://elements.heroku.com.
