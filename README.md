# <img src="https://cloud.githubusercontent.com/assets/7833470/10899314/63829980-8188-11e5-8cdd-4ded5bcb6e36.png" height="60"> Rails Bog App

Researchers are collecting data on a local bog and need an app to quickly record field data. Your goal is to create a **Bog App**.

| Objectives |
| :--- |
| Review **CRUD** in the context of a Rails application, especially **updating** and **deleting** a resource. |
| Implement **form helpers** and **partials** in a  Rails application. |

If you get stuck at any point, feel free to reference the <a href="https://github.com/sf-wdi-24/rails_bog_app/tree/solution" target="_blank">working solution code</a>.

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

## Part I: Displaying All Creatures with `index`

#### 1. Set up a new Rails project

Fork this repo, and clone it into your `develop` folder on your local machine. Change directories into `rails_bog_app`, and create a new Rails project:

```zsh
➜  rails new bog_app -T
➜  cd bog_app
➜  rake db:create
➜  rails s
```

Your app should be up and running at localhost:3000.

#### 2. Add Bootstrap

Rails handles CSS and JavaScript with a system called the asset pipeline. We'll go over it more next week, but for now, you'll add Bootstrap via the asset pipeline.

Third-party libraries belong in the `vendor/assets` sub-directory of your Rails app. Use the following Terminal command to download the Bootstrap CSS file (via `curl`) and save it in a new `bootstrap-3.3.6.min.css` file inside the `vendor/assets/stylesheets` sub-directory.

```zsh
➜  curl https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css > vendor/assets/stylesheets/bootstrap-3.3.6.min.css
```

#### 3. Define `root` and creatures `index` routes

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

#### 4. Creatures Controller, Index Action

Let's begin by having Rails generate a creatures controller for us. Run the following command in your Terminal.

```bash
rails g controller creatures
```

Next, we'll set up our `creatures#index` method (you'll often see this syntax for methods inside controllers, which are referred to as "controller actions": `controller#action`).

```ruby
# app/controllers/creatures_controller.rb

class CreaturesController < ApplicationController
	# show all creatures
	def index
		# get all creatures from db and save to instance variable
		@creatures = Creature.all  
		# render index view file (it will have access to instance variables)
		render :index
	end
end
```

#### 5. Create a creature

In Terminal, we create our `Creature` model using a rails generator as follows:

```bash
 rails g model creature name description
```

Then migrate to update the database with this change:

```bash
rake db:migrate
```

#### 6. Verify it works

In the Terminal, enter the Rails console.  The Rails console is built on top of irb, but it has access to your Rails project. Use it to create a Creature model

```bash
rails console  # do this in the main Terminal (file system)
```

```ruby
Creature.create({name: "Yoda", description: "Green little man"})  # do this once you're inside Rails console
```

#### 7. Seeds

When we create an application in development, we typically will want some mock data to play with. In Rails, we can just drop this into the `db/seeds.rb` file.

Back in your text editor, add some seed data to `db/seeds.rb`.

```ruby
# db/seeds.rb

Creature.create({name: "Luke", description: "Jedi"})

Creature.create({name: "Darth Vader", description: "Father of Luke"})
```

Run `rake db:seed` in Terminal (not inside rails console!). Note that the seed file will also get run every time you `rake db:reset` to reset your database.

#### 8. Creatures index view

If you look at your views, the `views/creatures` folder has already been created. We just need to add the file below:

```html
<!-- app/views/creatures/index.html.erb` -->

<% @creatures.each do |creature| %>

	<div>
		Name: <%= creature.name %> <br>
		Description: <%=  creature.description %>
	</div>

<% end %>
```

If you haven't yet, make a git commit for your work so far.

## Part II: Make A Creature with `new` (form) and `create` (database)

#### 1. A route for the new creature form

The Rails convention is to make a form for new creatures available at the `/creatures/new` path in our browser. Let's use `resources` to add this route.

```ruby
#/config/routes.rb

Rails.application.routes.draw do
	root to: 'creatures#index'

	resources :creatures, only: [:index, :new]
	# resources :creatures with :new is equivalent to adding:
	# get "/creatures/new", to: "creatures#new", as: "new_creature"
end
```

#### 2. A `new` controller action for creatures

A GET request for `/creatures/new` will search for a `creatures#new` action, so we must create a method to handle this request. It will render the `new.html.erb` in the `app/views/creatures` folder.

```ruby
# app/controllers/creatures_controller.rb

class CreaturesController < ApplicationController

	# ... keep your other content, and add:
	# show the new creature form
	def new
		render :new   # optional; this is the default behavior
	end
end
```

#### 3. A view for the new creature form

Let's create the `app/views/creatures/new.html.erb` with a form that the user can use to sumbit new creatures to the application. Note: the url for the route is `/creatures` because it's the collection we are submiting to, and the method is `POST` because we want to create.

```html
<!-- app/views/creatures/new.html.erb -->

<%= form_for :creature, url: "/creatures", method: "post" do |f| %>
	<%= f.text_field :name %>
	<%= f.text_area :description %>
	<%= f.submit "save creature" %>
<% end %>
```

Go to `localhost:3000/creatures/new` and look through the HTML for the form that was created from this erb. `form_for` is a "form helper," and it sets up more than just what you might guess from its erb. Note the `method` and `action` in the form -- what route should we create next?

#### 4. A route to add new creatures to the database (create)

Let's define the route we just promised to set up when we said `url: "/creatures", method: "post"`. It's a `POST /creatures` route, and Rails calls this action `create`.

```ruby
#/config/routes.rb

Rails.application.routes.draw do
	root to: 'creatures#index'
	resource :creatures, only: [:index, :new, :create]
	# resources :creatures with :create is equivalent to adding:
	# post "/creatures", to: "creatures#create"
end
```

Run `rake routes` from the Terminal to see the new route that Rails created for you.

#### 5. A create controller action

Let's get this data into the database! We'll need to make a `creatures#create` controller action.

```ruby
#app/controllers/creatures_controller.rb

class CreaturesController < ApplicationController

	# keep your other methods, and add:
	# create a new creature in the database
	def create
		# validate params and save them as a variable
		creature_params = params.require(:creature).permit(:name, :description)
		# create a new creature with those params
		creature = Creature.new(creature_params)
		# check that it saved
		if creature.save
			# if saved, redirect to route that shows all creatures
			redirect_to creatures_path
			# ^ same as redirect_to "/creatures"
		end
	end
end
```

#### 6. A smarter view for the new creature form

Let's update our `creatures#new` action

```ruby
#app/controllers/creatures_controller.rb

class CreaturesController < ApplicationController

	# keep your other methods, and update new:
	def new
		@creature = Creature.new
		render :new
	end

end
```

This sets `@creature` to a new instance of a `Creature`, which we can now share with or view in `views/creatures/new.html.erb`. This lets us shorten the code for our `form_for` form helper.  

```html
<!-- app/views/creatures/new.html.erb -->

<%= form_for @creature do |f| %>
	<%= f.text_field :name %>
	<%= f.text_area :description %>
	<%= f.submit "save creature" %>
<% end %>
```

Go to `localhost:3000/creatures/new` again and look at the HTML of the form that resulted from this updated erb.

#### 7. Show route

Right now, our app redirects to `/creatures` after a creature is made, and the new creature shows up at the bottom of the page.  Let's make a route where users can go to see a specific creature. Then we'll be able to show a creature by itself right after it's created.

First, add a `show` route.  This sets up a `GET /creatures/:id`.

```ruby
# /config/routes.rb

Rails.application.routes.draw do
	root to: 'creatures#index'
	resources :creatures, only: [:index, :new, :create, :show]
	# resources :creatures with :show is equivalent to adding:
	# get "/creatures/:id", to: "creatures#show", as: "creature"
end
```

Now that we have our route, we'll add the controller action it uses.

```ruby
#app/controllers/creatures_controller.rb

class CreaturesController < ApplicationController

	# keep your other methods, and add:
	# show a single creature
	def show
		# get the id parameter from the url
		id = params[:id]
		# find the creature with that id and save to an instance variable
		@creature = Creature.find(id)
		# render the show page -- it will have access to the @creature variable
		render :show
	end

end
```

Now, let's set up the view that will show a single creature.

```html
<!-- app/views/creatures/show.html.erb -->

<div>
	Name: <%= @creature.name %> <br>
	Description: <%=  @creature.description %>
</div>
```

#### 8. Changing the `#create` redirect

The `creatures#create` method currently redirects to `/creatures`. Again, this isn't very helpful for users who want to verify that they successfully created a creature. The best way to fix this is to have it redirect to `/creatures/:id`  instead.

```ruby
# app/controllers/creatures_controller.rb

class CreaturesController < ApplicationController

	# keep your other methods the same, and update create to redirect to the creature show route:
	def create
		# validate params and save them as a variable
		creature_params = params.require(:creature).permit(:name, :description)
		# create a new creature with those params
		creature = Creature.new(creature_params)
		# check that it saved
		if creature.save
			# if saved, redirect to route that shows just this creature
			redirect_to creature
			# ^ same as redirect_to creature_path(creature)
			# ^ same as redirect_to "/creatures/#{creature.id}"
		end
	end
end
```

Make another git commit.

Part III: Change a Creature with `edit` (form) and `update` (database)

Editing a Creature model requires two seperate methods:

- `edit` displays a form with the model information to be edited by the user  
- `update` actually updates information in the database when the form is submitted  

If look back at how we set up our `new` form, we see the following pattern.

* Make a route first
* Define a controller action
* Render a form view

The only difference for editing is that now we'll need to know the `id` of the object to be edited. We'll follow this plan:

* Make a route first
	* Make sure it specifies the `id` of the record to be edited
* Define a controller action
	* Retrieve the `id` of the specific record to be edited from `params`
	* Use ActiveRecord and the `id` to find the record
* Render a form view
	* Display the edit form, with the current information from the record we found

#### 1. The edit route, controller action, and form

We begin with showing the edit form: this will be our server's response to a `GET /creatures/:id/edit` request from a client.  We can easily define a route to handle getting the edit page by expanding our `resources` in `routes.rb`.

```ruby
#/config/routes.rb

Rails.application.routes.draw do
	root to: 'creatures#index'
	resources :creatures, only: [:index, :new, :create, :show, :edit]
	# resources :creatures with :edit is equivalent to adding:
    	# get "/creatures/:id", to: "creatures#edit", as: "edit_creature"
end
```

Using our `#new` method as inspiration, we can write an `#edit` action in our creatures controller.

```ruby
#app/controllers/creatures_controller.rb`

class CreaturesController < ApplicationController

	# keep your other methods, and add:
	# show an edit form for a specific creature
	def edit
		# save the id parameter to a variable
		id = params[:id]
		# look up the creature by id and save to an instance variable
		@creature = Creature.find(id)
		# render the edit form view -- it will have access to the @creature instance variable
		render :edit
	end

end
```

Let's jump start an edit form by copying the form from our `views/creatures/new.html.erb` into `views/creatures/edit.html.erb`.

```html
<!-- app/views/creatures/edit.html.erb -->

<%= form_for @creature do |f| %>

	<%= f.text_field :name %>
	<%= f.text_area :description %>
	<%= f.submit "update creature" %>

<% end %>
```

Go to `localhost:3000/creatures/1/edit` to see what it looks like so far.  Check the `method` and `action` of the form. Also look at the `_method` input.  What is it doing?  The Rails form helper knew to turn this same code into an edit form on the edit page!

#### 2. Updating the database with form data

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

Test your update in the broswer by editing the creature with an `id` of 1 (go to `/creatures/1/edit`). Then, make another git commit.

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

If you were tempted to use [`Creature.delete`](http://apidock.com/rails/ActiveRecord/Base/delete/class) to delete from the database, that would be okay *in this case* because there are no relatonships or associations among resources in this app. However, get in the habit of using `creature.destroy` to avoid problems with related resources later.

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

## CONGRATULATIONS! You have created a Bog App! Take a break, you look *Swamped*!

![](https://cloud.githubusercontent.com/assets/7833470/11501240/83536030-97e7-11e5-8060-fa7666de7165.jpeg)

## Submission

Once you've finished the assignment and pushed your work to GitHub, make a pull request from your fork to the original repo.
