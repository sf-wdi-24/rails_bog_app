# <img src="https://cloud.githubusercontent.com/assets/7833470/10899314/63829980-8188-11e5-8cdd-4ded5bcb6e36.png" height="60"> Rails Bog App

| Objectives |
| :--- |
| Review **CRUD** in the context of a Rails application, especially **updating** and **deleting** a resource. |
| Implement **form helpers** and **partials** in a  Rails application. |

Researchers are collecting data on a local bog and need an app to quickly record field data. Your goal is to create a **Bog App**. If you get stuck at any point, feel free to reference the <a href="https://github.com/sf-wdi-24/rails_bog_app/tree/solution" target="_blank">solution branch</a>.

## Background

> A bog is a mire that accumulates peat, a deposit of dead plant material — often mosses.

You may hear bog and think of Yoda and Luke...

![](https://cloud.githubusercontent.com/assets/7833470/11500466/211c115a-97e2-11e5-9b7f-9fc900023d8d.jpeg)

Or maybe Sir Didymus and The Bog of Eternal Stench...

![](https://cloud.githubusercontent.com/assets/7833470/11500467/212e3c7c-97e2-11e5-9256-ca7e28cf6941.gif)

## CRUD and REST Reference

REST stands for **REpresentational State Transfer**. We will strictly adhere to RESTful routing for Rails resources, and Rails sets up a lot of it for us.

| Verb | Path | Action | Used for |
| :--- | :--- | :--- | :--- |
| GET | /creatures | index | displaying list of all creatures |
| GET | /creatures/new | new | displaying an HTML form to create a new creature |
| POST | /creatures | create | creating a new creature in the database |
| GET | /creatures/:id | show | displaying a specific creature |
| GET | /creatures/:id/edit | edit | displaying an HTML form to edit a specific creature |
| PUT or PATCH | /creatures/:id | update | updating a specific creature in the database |
| DELETE | /creatures/:id | destroy | deleting a specific creature in the database |

## Part I: Display all creatures with `index`

#### 1. Set up a new Rails project

Fork this repo, and clone it into your `develop` folder on your local machine. Change directories into `rails_bog_app`, and create a new Rails project:

```zsh
➜  rails new bog_app -T
➜  cd bog_app
➜  rake db:create
➜  rails s
```

Your app should be up and running at `localhost:3000`.

#### 2. Add Bootstrap to your project

Rails handles CSS and JavaScript with a system called the asset pipeline. We'll go over it more next week, but for now, you'll add Bootstrap via the asset pipeline.

Third-party libraries belong in the `vendor/assets` sub-directory of your Rails app. Use the following Terminal command to download the Bootstrap CSS file (via `curl`) and save it in a new `bootstrap-3.3.6.min.css` file inside the `vendor/assets/stylesheets` sub-directory.

```zsh
➜  curl https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css > vendor/assets/stylesheets/bootstrap-3.3.6.min.css
```

#### 3. Define the `root` and creatures `index` routes

In Sublime, open up `config/routes.rb`. Inside the routes `draw` block, erase all the commented text. It should now look exactly like this:

```ruby
#
# config/routes.rb
#

Rails.application.routes.draw do

end
```

Your routes tell your app how to direct **HTTP requests** to **controller actions**. Define your `root` and creatures `index` routes as follows:

```ruby
#
# config/routes.rb
#

RouteApp::Application.routes.draw do
  root to: "creatures#index"

  # use the resources method to have Rails make an index route for creatures
  resources :creatures, only: [:index]

  # resources :creatures, only: [:index] is equivalent to:
  # get "/creatures", to: "creatures#index"
end
```

In the Terminal, running `rake routes` will list all your routes. You'll see that some routes have a "prefix" listed. These routes have associated route helpers, which are methods Rails creates for us to generate URLs. The format of a route helper is `prefix_path`. For example, `creatures_path` is the full route helper for `GET /creatures` (the creatures index). We often use route helpers to generate URLs in forms, links, and controllers.

#### 4. Set up the creatures controller and `index` action

Run the following command in the Terminal to generate a controller for creatures:

```zsh
➜  rails g controller creatures
```

Next, define the `creatures#index` action in the creatures controller:

```ruby
#
# app/controllers/creatures_controller.rb
#

class CreaturesController < ApplicationController

  # display all creatures
  def index
    # get all creatures from db and save to instance variable
    @creatures = Creature.all
    
    # render the index view (it has access to instance variables)
    render :index
  end

end
```

#### 5. Set up the creature model

Run the following command in the Terminal to generate the `Creature` model:

```zsh
➜  rails g model creature name description
```

Run the migration to update the database with this change:

```zsh
➜  rake db:migrate
```

#### 6. Create a creature

In the Terminal, enter the Rails console. The Rails console is built on top of `irb`, and it has access to your Rails project. Use it to create a new instance of a creature.

```zsh
➜  rails c
irb(main):001:0> Creature.create({name: "Yoda", description: "Little green man"})
```

#### 7. Seed your database

When you create an application in development, you typically want some mock data to play with. In Rails, you can just drop this into the `db/seeds.rb` file.

Back in Sublime, add some seed data to `db/seeds.rb`:

```ruby
#
# db/seeds.rb
#

Creature.create({name: "Luke", description: "Jedi"})
Creature.create({name: "Darth Vader", description: "Father of Luke"})
```

In the Terminal (not inside rails console!), run `rake db:seed`. Note that the seeds file will also run every time you run `rake db:reset` to reset your database.

#### 8. Set up the creatures `index` view

If you look inside the `app/views` directory, the `/creatures` folder has already been created (this happened when you ran `rails g controller creatures`). Add an `index.html.erb` file to the `app/views/creatures` folder.

Inside your creatures index view, iterate through all the creatures in the database, and display them on the page:

```html
<!-- app/views/creatures/index.html.erb -->

<% @creatures.each do |creature| %>
  <p>
    <strong>Name:</strong> <%= creature.name %><br>
    <strong>Description:</strong> <%=  creature.description %>
  </p>
<% end %>
```

If you haven't already, `git add` and `git commit` the work you've done so far.

## Part II: Make a creature with `new` (form) and `create` (database)

#### 1. Define a route for the `new` creature form

The Rails convention is to make a form for new creatures at the `/creatures/new` path in our browser. Use `resources` to add this route:

```ruby
#
#/config/routes.rb
#

Rails.application.routes.draw do
  root to: "creatures#index"

  resources :creatures, only: [:index, :new]

  # resources :creatures, only: [:index, :new] is equivalent to:
  # get "/creatures", to: "creatures#index"
  # get "/creatures/new", to: "creatures#new"
end
```

#### 2. Set up the creatures `new` action

When a user sends a GET request to `/creatures/new`, your server will search for a `creatures#new` action, so you need to create a controller method to handle this request. `creatures#new` should render the view `new.html.erb` inside the `app/views/creatures` folder.

```ruby
#
# app/controllers/creatures_controller.rb
#

class CreaturesController < ApplicationController

  ...

  # show the new creature form
  def new
    render :new
  end

end
```

#### 3. Set up the view for the new creature form

Create the view `new.html.erb` inside the `app/views/creatures` folder. On this view, users should see a form to create new creatures in the database.

**Note:** The URL you're submitting the form to is `/creatures` because it's the database collection for creatures, and the method is `POST` because you're *creating* a new creature.

```html
<!-- app/views/creatures/new.html.erb -->

<%= form_for :creature, url: "/creatures", method: "post" do |f| %>
  <%= f.text_field :name %>
  <%= f.text_area :description %>
  <%= f.submit "Save Creature" %>
<% end %>
```

Go to `localhost:3000/creatures/new` in the browser, and inspect the HTML for the form on the page. `form_for` is a "form helper", and it generates more than what you might guess from the `erb` you wrote in the view. Note the `method` and `action` in the form - what route do you think we should define next?

#### 4. Define a route to `create` creatures in the database

Your new creature form has `action="/creatures"` and `method="POST"`. The `POST /creatures` route doesn't exist yet, so go ahead and create it!

```ruby
#
#/config/routes.rb
#

Rails.application.routes.draw do
  root to: "creatures#index"

  resources :creatures, only: [:index, :new, :create]

  # resources :creatures, only: [:index, :new, :create] is equivalent to:
  # get "/creatures", to: "creatures#index"
  # get "/creatures/new", to: "creatures#new"
  # post "/creatures", to: "creatures#create"
end
```

#### 5. Set up the creatures `create` action

The `POST /creatures` maps to the `creatures#create` controller action, so the next step is to define the controller method to handle this request. `creatures#create` should add a new creature to the database.

```ruby
#
# app/controllers/creatures_controller.rb
#

class CreaturesController < ApplicationController

  ...

  # create a new creature in the database
  def create
    # whitelist params and save them to a variable
    creature_params = params.require(:creature).permit(:name, :description)
    
    # create a new creature from `creature_params`
    creature = Creature.new(creature_params)
    
    # if creature saves, redirect to route that displays all creatures
    if creature.save
      redirect_to creatures_path
      # redirect_to creatures_path is equivalent to:
      # redirect_to "/creatures"
    end
  end

end
```

#### 6. Refactor the `new` creature form

Update your `creatures#new` action to send a new instance of a `Creature` to the new creature form:

```ruby
#
# app/controllers/creatures_controller.rb
#

class CreaturesController < ApplicationController

  ...

  # show the new creature form
  def new
    @creature = Creature.new
    render :new
  end

end
```

This sets `@creature` to a new instance of a `Creature`, which is automatically shared with the form in `views/creatures/new.html.erb`. This allows you to refactor the code for the `form_for` helper.

```html
<!-- app/views/creatures/new.html.erb -->

<%= form_for @creature do |f| %>
  <%= f.text_field :name %>
  <%= f.text_area :description %>
  <%= f.submit "Save Creature" %>
<% end %>
```

Go to `localhost:3000/creatures/new` again in the browser, and inspect the HTML for the form on the page. Did anything change?

#### 7. Define a route to `show` a specific creature

Right now, your app redirects to `/creatures` after creating a new creature, and the new creature shows up at the bottom of the page. Let's make a route for users to see a specific creature. Then, you'll be able to show a new creature by itself right after it's created.

First, define a `show` route:

```ruby
#
# config/routes.rb
#

Rails.application.routes.draw do
  root to: "creatures#index"

  resources :creatures, only: [:index, :new, :create, :show]

  # resources :creatures, only: [:index, :new, :create, :show] is equivalent to:
  # get "/creatures", to: "creatures#index"
  # get "/creatures/new", to: "creatures#new"
  # post "/creatures", to: "creatures#create"
  # post "/creatures/:id", to: "creatures#show"
end
```

Now that you have your `show` route, set up the controller action for `creatures#show`:

```ruby
#
# app/controllers/creatures_controller.rb
#

class CreaturesController < ApplicationController

  ...

  # display a specific creature
  def show
    # get the creature id from the url params
    creature_id = params[:id]

    # use `creature_id` to find the creature in the database
    # and save it to an instance variable
    @creature = Creature.find_by_id(creature_id)
    
    # render the show view (it has access to instance variables)
    render :show
  end

end
```

Next, create the view to display a single creature:

```html
<!-- app/views/creatures/show.html.erb -->

<h3><%= @creature.name %></h3>
<p><%=  @creature.description %></p>
```

#### 8. Refactor the `creatures#create` redirect

The `creatures#create` method currently redirects to `/creatures`. Again, this isn't very helpful for users who want to verify that they successfully created a *single* creature. The best way to fix this is to have it redirect to `/creatures/:id` instead.

```ruby
#
# app/controllers/creatures_controller.rb
#

class CreaturesController < ApplicationController

  ...

  # create a new creature in the database
  def create
    # whitelist params and save them to a variable
    creature_params = params.require(:creature).permit(:name, :description)
    
    # create a new creature from `creature_params`
    creature = Creature.new(creature_params)
    
    # if creature saves, redirect to route that displays all creatures
    if creature.save
      redirect_to creature_path(creature)
      # redirect_to creature_path(creature) is equivalent to:
      # redirect_to "/creatures/#{creature.id}"
    end
  end

end
```

Make sure to `git add` and `git commit` again once you have `new`, `create`, and `show` working.

## Part III: Change a creature with `edit` (form) and `update` (database)

Editing a specific creature requires two methods:

* `edit` displays a form with the existing creature info to be edited by the user
* `update` changes the creature info in the database when the user submits the form

If you look back to how you set up your new creature form, you see the following pattern:

* Make the route first
* Define the controller action
* Render the view with the form

The only difference for editing is that now you'll need to know the `id` of the creature to be edited. You'll follow this plan:

* Make the route first
  * Make sure it specifies the `id` of the creature to be edited
* Define the controller action
  * Get the `id` of the specific creature from `params`
  * Use the `id` to find the creature in the database
* Render the view with the form
  * Display the edit form, with the current information for the creature to be edited

#### 1. Define a route for the `edit` creature form

Use `resources` to define a route that displays the edit creature form:

```ruby
#
# config/routes.rb
#

Rails.application.routes.draw do
  root to: "creatures#index"

  resources :creatures, only: [:index, :new, :create, :show, :edit]

  # resources :creatures, only: [:index, :new, :create, :show, :edit] is equivalent to:
  # get "/creatures", to: "creatures#index"
  # get "/creatures/new", to: "creatures#new"
  # post "/creatures", to: "creatures#create"
  # post "/creatures/:id", to: "creatures#show"
  # get "/creatures/:id/edit", to: "creatures#edit"
end
```

#### 2. Set up the creatures `edit` action

Using your `creatures#new` and `creatures#show` method as inspiration, you can write the `creatures#edit` method in the creatures controller:

```ruby
#
# app/controllers/creatures_controller.rb
#

class CreaturesController < ApplicationController

  ...

  # show the edit creature form
  def edit
    # get the creature id from the url params
    creature_id = params[:id]

    # use `creature_id` to find the creature in the database
    # and save it to an instance variable
    @creature = Creature.find_by_id(creature_id)
    
    # render the edit view (it has access to instance variables)
    render :edit
  end

end
```

#### 3. Set up the view for the edit creature form

Create an `edit.html.erb` view inside `views/creatures`. Jump start the edit form by copying the form from `views/creatures/new.html.erb` into `views/creatures/edit.html.erb`:

```html
<!-- app/views/creatures/edit.html.erb -->

<%= form_for @creature do |f| %>
  <%= f.text_field :name %>
  <%= f.text_area :description %>
  <%= f.submit "Save Creature" %>
<% end %>
```

Go to `localhost:3000/creatures/1/edit` in the browser to see what it looks like so far.  Check the `method` and `action` of the form. Also look at the `_method` input.  What is it doing? The Rails form helper knows to turn this same code into an edit form because you're on the edit page!


#### 4. Updating the database with form data

Looking back at how we handled the submission of our `new` form, we see that the task of creating an item in the database used the following pattern.

* Make a route first.
* Define a controller action.
* Redirect to some view.

The only difference for updating versus creating is that now we will need to keep track of the `id` of the object being updated.

* Make a route first.
  * Make sure it specifies the `id` of the thing to be **updated**
* Define a controller action.
  * Retrieve the `id` of the record to be **updated** from `params`
  * Use the `id` to find the record
  * Retrieve the updated info sent from the form in `params`
  * Update the record
* Redirect to show the updated record.
  * Use `id` to redirect to that item's show page

The update route will use the `id` of the object to be updated. In Express, we decided between `PUT /creatures/:id` and `PATCH /creatures/:id`.  When we add `:update` to our creatures `resources` in `routes.rb`, Rails creates both routes!

```ruby
#/config/routes.rb

Rails.application.routes.draw do
  root to: 'creatures#index'
  resources :creatures, only: [:index, :new, :show, :create, :edit, :update]
  # resources :creatures with :update is equivalent to adding BOTH:
  # patch "/creatures/:id", to: "creatures#update"
  # AND
  # put "/creatures/:id", to: "creatures#update"
end
```

Run `rake routes` in the Terminal to see the newly created update routes.

In the `CreaturesController`, create an `update` action.

```ruby
# app/controllers/creatures_controller.rb

class CreaturesController < ApplicationController

  # keep your other methods and add:
  # update a creature in the database
  def update
    # save the id paramater from the url
    creature_id = params[:id]
    # find the creature to update by id
    creature = Creature.find(creature_id)

    # get updated creature data from params
    updated_attributes = params.require(:creature).permit(:name, :description)
    # update the creature
    creature.update_attributes(updated_attributes)

    # redirect to single creature show page for this creature
    redirect_to creature
    # ^ same as redirect_to creature_path(creature)
    # ^ same as redirect_to "/creatures/#{creature.id}"
  end
end
```

Test your update in the browser by editing the creature with an `id` of 1 (go to `/creatures/1/edit`). Then, make another git commit.



## Part IV: Delete a Creature with Delete/Destory

#### 1. Destroy

Following a similar pattern to the above, we have Rails `resources` create a route to destroy (delete) a specific record based on its `id`.  The RESTful route it creates is `DELETE /creatures/:id`.

```ruby

#/config/routes.rb

Rails.application.routes.draw do
  root to: 'creatures#index'
  resources :creatures, only: [:index, :new, :show, :create, :edit, :update, :destroy]
  # resources :creatures with :destroy is equivalent to adding:
  # delete "/creatures/:id", to: "creatures#destroy"
end
```

Next, we create a controller action for this new route, in the `CreaturesController`.

```ruby
#app/controllers/creatures_controller.rb

class CreaturesController < ApplicationController

  # keep your other methods, and add:
  # delete a specific creature by id
  def destroy
    # save the id parameter
    id = params[:id]
    # find the creature to delete by id
    creature = Creature.find(id)
    # destroy the creature
    creature.destroy
    # redirect to creatures index
    redirect_to creatures_path
    # ^ same as redirect_to "/creatures"
  end

end
```

If you were tempted to use [`Creature.delete`](http://apidock.com/rails/ActiveRecord/Base/delete/class) to delete from the database, that would be okay *in this case* because there are no relationships or associations among resources in this app. However, get in the habit of using `creature.destroy` to avoid problems with related resources later.

Let's add a delete button in an existing view.

```html
<!-- app/views/creatures/index.html.erb -->

<% @creatures.each do |creature| %>
  <div>
    Name: <%= creature.name %> <br>
    Description: <%=  creature.description %>
        <%= button_to "Delete", creature, method: :delete %>
  </div>
<% end %>
```

Visit `localhost:3000/` and check out the delete button HTML.  Clicking one of the delete buttons to manually test your delete feature.

At this point, we have used all the RESTful routes for creatures.  Refactor your `config/routes.rb` to use reflect that we're using all of `resources` for creatures (remove the `only:` part).

```ruby
#/config/routes.rb
Rails.application.routes.draw do
  root to: 'creatures#index'
  resources :creatures
  # ^ same as resources :creatures, only: [:index, :new, :create, :show, :edit, :update, :destroy]
end
```

At this point, you've created all the RESTful routes, implemented controller actions for each route, and made views for index, show, new, and edit. You've also created the model in the database and manually tested that everything works.

## Submission

Once you've finished the assignment and pushed your work to GitHub, make a pull request from your fork to the original repo.

## CONGRATULATIONS! You have created a Bog App! Take a break, you look *Swamped*!

![](https://cloud.githubusercontent.com/assets/7833470/11501240/83536030-97e7-11e5-8060-fa7666de7165.jpeg)
