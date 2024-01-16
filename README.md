# **Cookpendium**

![](https://github.com/CharlieIGG/cookpendium/workflows/specs/badge.svg)

## ⚠️**WARNING**: This application is still a Work-in-progress!

This is an application meant for parsing, showing, and creating recipes... backed by AI-Powered Tools.

## Table of contents

- [**Cookpendium**](#cookpendium)
  - [⚠️**WARNING**: This application is still a Work-in-progress!](#️warning-this-application-is-still-a-work-in-progress)
  - [Table of contents](#table-of-contents)
    - [**Environments \& URLs**](#environments--urls)
  - [**Development**](#development)
    - [**With Docker**](#with-docker)
      - [Prerequisites](#prerequisites)
      - [Installing Cookpendium](#installing-cookpendium)
      - [**Running Cookpendium**](#running-cookpendium)
      - [**Running specs**](#running-specs)
    - [**Without Docker**](#without-docker)
      - [**Prerequisites**](#prerequisites-1)
      - [**Installing Cookpendium**](#installing-cookpendium-1)
      - [**Running Cookpendium**](#running-cookpendium-1)
      - [**Running specs**](#running-specs-1)
    - [**Writing Specs**](#writing-specs)
    - [**Best Practices**](#best-practices)
    - [**Responsibility-separation Patterns**](#responsibility-separation-patterns)
    - [**Application Layers**](#application-layers)
  - [**Continuous Integration**](#continuous-integration)
  - [**Deploying**](#deploying)
  - [**TO-DO**](#to-do)
  - [**Contributing**](#contributing)

### **Environments & URLs**

- **Production** - TBD
- **Staging** - TBD

## **Development**

### **With Docker**

#### Prerequisites

You just need to have [docker compose](https://docs.docker.com/compose/) installed.

#### Installing Cookpendium

You don't need to install anything, and can just skip to the next section. 
Explanation: Running `docker-compose up` will build the image and install all the dependencies.
Additionally, `bin/dev-entrypoint.sh` will be run, and if necessary, it should setup the database.

Should something not work, then you can run `docker compose run web/test bash` to go inside the `web` or `test` container respectively, and then run `rails db:setup` or `rails db:create db:migrate` to ensure that you have a working database.

Optionally, you can seed the database by running `rails db:seed` inside the `web` container. Note that this is not run automatically in the entrypoint script.

#### **Running Cookpendium**

To run Cookpendium, you can simply run `docker-compose up` and then navigate to http://localhost:3000 in your browser.
If you want to have debugger access to the application, you can run `docker-compose run --service-ports web` instead.

#### **Running specs**

To run specs, you can simply run `docker compose up test` or `docker compose run test` if you want to have debugger access to the application.
For interactive debugging, you can run `docker compose run test bash`, and then run any commands that you want from there, such as `bundle exec rspec` or `bundle exec guard` (in order to responsively run tests as you update files).

### **Without Docker**

#### **Prerequisites**

Before you begin, ensure you have met the following requirements:

- You have installed the correct version of Ruby, which for this project is Ruby v3.2.2.
- You need bundler v2.4 installed.
- You have installed the correct version of Node.js, which for this project is Node v20.

#### **Installing Cookpendium**

To install Cookpendium, follow these steps:

1. Clone the repo.
2. Run `bundle install`.

#### **Running Cookpendium**


Start the server and the asset compilers using `foreman start -f Procfile.dev`.
Then, navigate to http://localhost:3000 in your browser.

#### **Running specs**

To run specs, you can do:

```
$ bundle exec rspec
```

Or for a specific file:

```
$ bundle exec rspec spec/models/user_spec.rb

```

The app has Guard installed, allowing you to automatically run specs as you change files. To turn on the watcher run:

```
$ bundle exec guard

```

> 💡 If you have questions or doubts about the current behavior of any component in the system, please take a look at any related specs, since they also function as a way of documenting desired behaviors that might not be 100% explicit in the component itself.

### **Writing Specs**

All of our specs are based on [RSpec](https://rspec.info/), as well as [Capybara](https://teamcapybara.github.io/capybara/) and [Selenium WebDriver](https://www.selenium.dev/projects/) for Integration specs. [Our Philosophy is completely oriented towards a combination of BDD and DDD](https://medium.com/datadriveninvestor/the-value-at-the-intersection-of-tdd-ddd-and-bdd-da58ea1f3ac8).

Please refer to our [writing specs](docs/writing_specs.rb) section for more details specific to this project.


### **Best Practices**

Before you write any new features for this application it is strongly recommended to have a look at [This document of "Best Practices" for Rails applications](https://docs.google.com/document/d/1YZ1L4h2TMJ07YFN7dN_3lZSDB17iRUE0XLKMOZhHoNg/edit#heading=h.1doftf9akxl5).

### **Responsibility-separation Patterns**

This application's back-office follows as [MVC Pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller), while the API follows a "Resource-Controller" pattern in its majority.

### **Application Layers**

1. **Migrations and DB Schema**: Manage and map the Database
2. **Models**: Add higher-level rules and behaviors that correlate to the Database schema and enhance existing instances of every entry in every "modelled" table in the database.
3. **Resources**: Map and Serialize Models that shall be exposed via the API, as well as certain rules and behavior for said exposition.
4. **Policies and Policy Scopes**: determine the ability (or inability) to interact in different ways with specific Models/Resources, in a Identity- and Role-based way. Policy Scopes determine exactly what records can be accessed (if at all) by a given user, based on the user's identity and role(s).
5. **Controllers**: Recieve requests, delegate execution to the lower layers, respond something.
6. **Decorators**: Augment models with additional representational behavior, while helping us encapsulate and isolate representational behavior from inherent relational and functional behavior. **Helps us keep our Views clean and simple**.
7. **Views**: Render the GUI, typically served by the controllers based on the controller action name.
8. **Javascript**: Augment the views with dynamic, client-side behavior and logic, from pre-compiled libraries, to our own Stimulus controllers

## **Continuous Integration**

We use [GitHub Actions](https://github.com/features/actions) as the driver to run our CI, and Heroku as the driver to our CD (see [below](#deploying)).
Check out the [.github/workflows](.github/workflows) for the configuration of tasks that are run as part of the GitHub Actions Pipeline.

Most importantly we have the [continuous_integration.yml](.github/workflows/continuous_integration.yml) file, which will run all specs as soon as a new version of a new branch is deployed to GitHub, and the status of this run will be shown in any PR. It is encouraged that we create Branch-Protection rules based on the results of these workflows.

The results of these workflows can also be shown at the top of the repository, take a look at the badge near the header of this README.

The result of these workflows is currently also acting as a blocking mechanism for the automated deploys (see below).

## **Deploying**

TBD

## **TO-DO**

See the [Projects](https://github.com/CharlieIGG/Cookpendium/projects) section to find out more about planned and in-progress to-dos.

## **Contributing**

Feel free to create forks + pull requests for this project with new features and bug-fixes.
If you're wanting to implement a functionallity that is very specific to your use case or industry, it should be added in a modular way (as an opt-in feature).