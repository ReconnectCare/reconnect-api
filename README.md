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
