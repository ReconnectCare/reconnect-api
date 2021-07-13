# README

## System dependencies

* Postgres
* -Redis-

## Gems

* Slim: <https://github.com/slim-template/slim>
* Devise: <https://github.com/plataformatec/devise>
* Cancancan: <https://github.com/CanCanCommunity/cancancan>
* Simple_form: <https://github.com/plataformatec/simple_form>
* Pagy: <https://ddnexus.github.io/pagy/how-to>
* exception_notification: <https://github.com/smartinez87/exception_notification>
* http: <https://github.com/httprb/http>
* VCR: <https://relishapp.com/vcr/vcr/v/5-0-0/docs/getting-started>
* factory_bot: <https://github.com/thoughtbot/factory_bot>
* guard: <https://github.com/guard/guard>
* solargraph
* standardrb: <https://github.com/testdouble/standard>
* inky-rb: <https://github.com/foundation/inky-rb>
* Sidekiq: <https://github.com/mperham/sidekiq>
* Hotwire

## JavaScript/CSS

* TailwindCSS: <https://tailwindcss.com/docs/>
* Font Awesome: <https://fontawesome.com/how-to-use/on-the-web/referencing-icons/basic-use>
* StimulusJS: <https://stimulusjs.org/handbook/installing>

## Functionality

### Pagy

In controller

    @pagy, @records = pagy(Product.some_scope)

In View

    <%== pagy_nav(@pagy) %>

# Setup

* Change database names in database.yml
* Find and replace

    rg -l ReconnectApi | xargs -n 1 sed -i'' -e 's/ReconnectApi/Profilrr/g'

    rg -l 'RAILS_STARTER_6' | xargs -n 1 sed -i '' -e 's/RAILS_STARTER_6/RECONNECT_API/g'

    rg -l 'rails_starter_6' | xargs -n 1 sed -i '' -e 's/rails_starter_6/reconnect_api/g'

    rg -l 'rails-starter-6' | xargs -n 1 sed -i '' -e 's/rails-starter-6/reconnect-api/g'

    rg -l 'rails_starter6' | xargs -n 1 sed -i '' -e 's/rails_starter6/reconnect_api/g'

    rg -l 'rails-starter6' | xargs -n 1 sed -i '' -e 's/rails-starter6/reconnect-api/g'

    rg -l 'Rails Starter 6' | xargs -n 1 sed -i '' -e 's/Rails Starter 6/Reconnect Api/g'

    # check
    rg -i 'rails[- _]*starter[- _]*6'

Setup Data

    rails db:create
    rails db:migrate
    rails db:seed

If using puma-dev

    puma-dev link

API

**Auth Token**

    curl -v -d "email=candland@gmail.com" \
        -d "password=password" \
        http://localhost:5000/api/v1/auth | jq

    {
      "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMzQ4MjM0ZGUtNjMwYi00MTY3LTkwNzQtZTJkMDViMDU1NTkxIn0.J20wvEFmG1p5KDhCxHDDJt0CN_hYADU88mQ5qNqxEbY"
    }

 **Me**

    curl -v -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMzQ4MjM0ZGUtNjMwYi00MTY3LTkwNzQtZTJkMDViMDU1NTkxIn0.J20wvEFmG1p5KDhCxHDDJt0CN_hYADU88mQ5qNqxEbY" \
        http://localhost:5000/api/v1/me | jq

    {
      "id": "348234de-630b-4167-9074-e2d05b055591",
      "email": "candland@gmail.com",
      "first_name": "Dusty",
      "last_name": "Candland",
      "avatar_url": "https://www.gravatar.com/avatar/612e515cd7fa5fa4713db45a7a825166?s=64&d=mg",
      "roles": [
        "user",
        "admin"
      ]
    }

**Create Conference**

    curl -v -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMzQ4MjM0ZGUtNjMwYi00MTY3LTkwNzQtZTJkMDViMDU1NTkxIn0.J20wvEFmG1p5KDhCxHDDJt0CN_hYADU88mQ5qNqxEbY" \
        -d 'external_id=test1' \
        -d 'reason=back pain' \
        -d 'patient[external_id]=patient' \
        -d 'patient[first_name]=first patient' \
        -d 'patient[middle_name]=middle patient' \
        -d 'patient[last_name]=last patient' \
        -d 'patient[date_of_birth]=2000-12-31' \
        -d 'patient[gender]=male' \
        -d 'patient[office_phone]=' \
        -d 'patient[cell_phone]=303-359-3041' \
        -d 'patient[email]=candland@gmail.com' \
        -d 'patient[street]=123 main st' \
        -d 'patient[street_2]=' \
        -d 'patient[city]=anytown' \
        -d 'patient[state]=CA' \
        -d 'patient[zipcode]=90121' \
        http://localhost:5000/api/v1/conferences | jq

**Example error response**

    {
      "message": "conference_number",
      "errors": [
        "no available numbers."
      ]
    }

**Success response**

    {
      "id": "80641d35-0737-4da7-b336-c6095b7f780d",
      "sid": null,
      "start_time": "2021-06-10T15:10:19.372Z",
      "end_time": null,
      "status": "ready",
      "reason": "back pain",
      "conference_number": {
        "id": "af6974b2-05bb-44e3-a763-e76aef3fc56f",
        "number": "+17207041440",
        "created_at": "2021-05-24T20:34:13.544Z",
        "updated_at": "2021-05-24T22:11:17.132Z"
      },
      "patient": {
        "id": "905fd797-e7ea-4d49-a7c6-36ad2725bf8d",
        "external_id": "patient",
        "first_name": "first patient",
        "middle_name": "middle patient",
        "last_name": "last patient",
        "date_of_birth": "2000-12-31",
        "gender": "male",
        "office_phone": "",
        "cell_phone": "+13038752721",
        "email": "candland@gmail.com",
        "street": "123 main st",
        "street_2": "",
        "city": "anytown",
        "state": "CA",
        "zipcode": "90121",
        "created_at": "2021-06-10T15:09:10.980Z",
        "updated_at": "2021-06-10T15:09:10.980Z"
      },
      "created_at": "2021-06-10T15:10:26.987Z",
      "updated_at": "2021-06-10T15:10:26.987Z"
    }
