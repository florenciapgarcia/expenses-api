# Expenses API

### Prerequisites

The setups steps expect following tools installed on the system.

* Github
* Ruby 3.1.2
* Rails 7.0.4.2

### Installation guide

1. Clone this repository
2. Run `bundle install`
3. To start the server run `rails s`

### Usage

### API Endpoints

| HTTP Verbs | Endpoints                        | Action                                                      |
|------------|----------------------------------|-------------------------------------------------------------|
| POST       | /api/user/login                  | To login an existing user account                           |
| DELETE     | /api/user/logout                 | To logout an existing user account                          |
| POST       | /api/users                       | To create a new user                                        |
| PATCH      | /api/users/:user_id              | To edit the details of a single user                        |
| DELETE     | /api/users/:user_id              | To delete a single user                                     |
| GET        | /api/users/:user_id/expenses     | To retrieve all the expenses for the logged in user         |
| GET        | /api/users/:user_id/expenses/:id | To retrieve a single expense for the logged in user         |
| POST       | /api/users/:user_id/expenses/:id | To create a new expense for the logged in user              |
| PATCH      | /api/users/:user_id/expenses/:id | To edit the details a single expense for the logged in user |
| DELETE     | /api/users/:user_id/expenses/:id | To delete a single expense for the logged in user           |

### Technologies Used

* [Rails](https://rubyonrails.org/) Ruby on Rails (simplified as Rails) is a server-side web application framework
  written in Ruby under the MIT License. Rails is a model–view–controller (MVC) framework, providing default structures
  for a database, a web service, and web pages.
