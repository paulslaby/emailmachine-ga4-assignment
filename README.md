# Pavel Buchart's GA4 assignment

It took about 3-4 hours.
1 hour wasted trying to understand the new GA gems/APIs (Last time I was working with those, GA4 was a fresh one, most of our customers still used Universal Analytics).

## How to run

### Prerequisites

* ruby 3.2.2
* clone this repository and enter its directory

### Install libraries

* `bundle install`

### Google credentials

We use a service sccount credentials. Set the path to yout json credentials file to the env variable GOOGLE_APPLICATION_CREDENTIALS. 
Example: `export GOOGLE_APPLICATION_CREDENTIALS="config/google_credentials.json"`

### Run rails server

`bundle exec rails s`

### Use the application

Navigate to [localhost:3000](http://localhost:3000)

## Architecture

### Controllers

Just one GoogleAnalyticsOperations with just two actions:

* show - for showing the resuts, input form and also outputs
* update - for performing the GA operation

### Frontend

I avoided trying to make it beautiful, but kept it simple.

#### Considerations:

We can show the data in a graph by dates. If we wanna emphasis benefits of our tools, we can use calendar date and total numbers.
If we wanna offer analysis of a campaign, we can make the dates relative to sending date. (example: most of the purchases comes in the first week)

### Calculations

See GoogleAnalyticsOperationsHelper.

#### Considerations

* Conversion rate: It's not defined what is the base for the conversions. I assumed it's a part of visits who made a transaction out of those who saw the email. (alternatively, we can talk about customer, not visits)

* ROI: It's not known for me, how many emails had been sent. I assume visits means opened email. Therefore I counted just visits to calculate the costs.

### Next steps

* Authentication to out app.
* Allow users to create their accounts and their own connections to their own GA accounts.
* Frontend - Make users love that product.
