# Welcome to the Bog App

Researchers are collecting data on a local bog and need app to quickly record field data. Our goal is to create a **Bog App**.

## Intro

| Objectives |
| :---- |
| Review **CRUD** in the context of a Rails application, especially **Updating** and **Deleting** a resource. |
| Examine **form helpers** and **partials** (if time permits) in a  Rails Application. |
| Apply styling and **Bootstrap** to our site to create a custom layout. |

## Background

| Background |
| :--- |
| A bog is a mire that accumulates peat, a deposit of dead plant material—often mosses. |

I hear bog and think of Yoda and Luke...

![luke](http://1.bp.blogspot.com/-Aa0TuXoIMoU/T4M7_GbT8uI/AAAAAAAAin8/lcUZkoqoJM4/s1600/Yoda-and-Luke.jpg)

<!--Or maybe Etrayu and The Swamps of Sadness...-->
<!--![Bye Bye, Artax!](https://readingotherpeople.files.wordpress.com/2015/06/artax.jpg)  -->
 
Or maybe Sir Didymus and The Bog of Eternal Stench...
![Bog of Etneral Stench](http://amazingradio.com/wp-content/uploads/tumblr_mphici3ZJB1rm1bf5o1_500.gif)


## Outline


Part I: Showing All Creatures with Index

* Set up a new project.
* Drop in Bootstrap.
* Set up a **`/creatures/`** index route and view template.
* Create a **Creature** model.
	* verify it works in console
	* make your `creatures#index` controller action send all creature data to the creatures index view
	* display all creatures by iterating over them in the creatures index view
	
Part II: Make A Creature with New (form) and Create (database)

* Make a new creature from a form
	* Set up a **GET `/creatures/new`** route
	* Use a `creatures#new` controller action display a new creature form (with form helpers!)
	* Set up a **POST `/creatures/create`** route 
	* Use a `creatures#create` route to make a new `Creature` and save it to the database

* Show a single creature
	* Set up a **GET `/creatures/:id`** route
	* Use a `creatures#show` controller action to render a view template for a single `creature`

Part III: Change a Creature with Edit (form) and Update (database) 

* Set up a **GET `/creatures/:id/edit`** route and a creatures#edit controller action to display an edit creature form view.
* Set up a **PUT or PATCH `creatures/:id`** route and a creatures#update controller action to update one creature and save it to the database based on the edit form. 

Part IV: Delete a Creature with Delete/Destory
* Setup a **DELETE  `/creatures/:id`** route and a creatures#destroy controller action to delete a particular creature from the database.
* Add a delete button to a view so the user can trigger the delete request.


## CRUD and REST Reference

Memorize this:

![Restful Routes](http://i.stack.imgur.com/RyM1b.png)

REST stands for **REpresentational State Transfer**. We will strictly adhere to RESTful routing for Rails resources, but Rails will set up a lot of it for us.

## Part I: Showing All Creatures with Index 

### 1. Set up a new Rails project

In the Terminal, run the following commands:

* `rails new bog_app -T --database=postgresql` to create a new Rails project called `bog_app`, without including tests (`-T`), using the PostgreSQL database
* `cd bog_app` to move into the new `bog_app` directory
* `rake db:create` to have Rails set up a database for the new app
* `rails s` or `rails server` to start the WEBrick server

Now our app is up and running at [localhost:3000](localhost:3000/).

### 2. Drop in Bootstrap

Rails handles JavaScript and CSS with a system called the asset pipeline. We'll go over it more next week, but for now we'll just drop Bootstrap into it. 

For the asset pipeline, third party css libraries belong in `vendor/assets`. We'll add Bootstrap's minified css to the `vendor/assets/stylesheets` directory.  Use the following Terminal command to download the Bootstrap css file (the `curl` part) and save it in a new `bootstrap-3.2.0.min.css` file inside that directory (the part starting with `>`).

```bash
 curl https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css > vendor/assets/stylesheets/bootstrap-3.2.0.min.css
```

If you want to add other front-end libraries before we cover the asset pipeline, there is another option. Add the libraries to your pages with CDN links in the built-in partial `app/views/layouts/application.html.erb`.  This isn't the right way, but it's okay until we learn the asset pipeline.  Here's an example:

```html
<!--app/views/layouts/application.html.erb-->
<!DOCTYPE html>
<html>
	<head>
		<title>BogApp</title>
		<%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true %>
		<%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
		<%= csrf_meta_tags %>
	</head>
	<body>
		<%= yield %>
		<!-- include jQuery with a CDN -->
		<script src="https://code.jquery.com/jquery-2.1.4.min.js"></script>
	</body>
</html>
```

### 3. Routes

Go to `config/routes.rb`. Inside the routes `draw` block, you can erase all the commented text. It should now look exactly as follows:

```ruby
#config/routes.rb
Rails.application.routes.draw do

end
```

Now we start defining our routes.

Your routes tell your app how to direct *HTTP requests** to a **controller action**. Let's get ready for our first route.

> NOTE
>
> * The syntax for any route goes as follows:
>
>		request_type '/for/some/path/goes', to: "controller#method"
>
>	e.g. if we had a `PuppiesController` that had a `index` method we could say
>
>		get "/puppies", to: "puppies#index"
>
> * Rails also has a built-in shorthand to create routes: `resources`



### 4. Root and creatures index routes

Using the above routing pattern, we'll write our first route, the `GET /` or "root" route. 

```ruby
# /config/routes.rb

RouteApp::Application.routes.draw do
	root to: 'creautres#index'
	
	# We'll also use the resources method to have Rails 
	# make an index route for our creatures resource.
	# This will be at `GET /creatures`
	resources :creatures, only: [:index]
end
```

### 5. Creatures Controller, Index Action

Let's begin by having Rails generate a creatures controller for us. Run the following command in your Terminal.

```bash
rails g controller creatures
```

Next, we'll set up our `creatures#index` method (you'll often see this syntax for methods inside controllers, which are referred to as "controller actions": `controller#action`).

```ruby
# app/controllers/creatures_controller.rb

class CreaturesController < ApplicationController

	def index
		# get all creatures from db and save to instance variable
		@creatures = Creature.all  
		# render index view file (it will have access to instance variables)
		render :index
	end
end
```

### 6. Create a creature

In Terminal, we create our `Creature` model using a rails generator as follows:

```bash
 rails g model creature name description
```

Then migrate to update the database with this change:

```bash
rake db:migrate
```

#### Verify it works

In the Terminal, enter the Rails console.  The Rails console is built on top of irb, but it has access to your Rails project. Use it to create a Creature model

```bash
rails console  # do this in the main Terminal (file system)
Creature.create({name: "Yoda", description: "Green little man"})  # do this once you're inside Rails console
```


####Seeds

When we create an application in development, we typically will want some mock data to play with. In Rails, we can just drop this into the `db/seeds.rb` file.

Back in your text editor, add some seed data to `db/seeds.rb`.

```ruby
# db/seeds.rb

Creature.create({name: "Luke", description: "Jedi"})

Creature.create({name: "Darth Vader", description: "Father of Luke"})
```

Run ` rake db:seed` in Terminal. Note that the seed file will also get run every time you `rake db:reset` to reset your database.


### 8. Creatures index view

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

## Part II: Make A Creature with New (form) and Create (database)

### 9. A route for the new creature form

The Rails convention is to make a form for new creatures available at the `/creatures/new` path in our browser. Let's use `resources` to add this route.

```ruby
#/config/routes.rb

Rails.application.routes.draw do
	root to: 'creatures#index'
	resources :creatures, only: [:index, :new]
end
```

### 10. A `new` controller action for creatures

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

### 11. A view for the new creature form

Let's create the `app/views/creatures/new.html.erb` with a form that the user can use to sumbit new creatures to the application. Note: the url for the route is `/creatures` because it's the collection we are submiting to, and the method is `POST` because we want to create.

```html
<!-- app/views/creatures/new.html.erb -->

<%= form_for :creature, url: "/creatures", method: "post" do |f| %>
	<%= f.text_field :name %>
	<%= f.text_area :description %>
	<%= f.submit "save creature" %>
<% end %>
```

Go to `localhost:3000/creatures/new` and look at the HTML for the form created by this erb. `form_for` is a "form helper." Note the `method` and `action` in the form -- what route should we create next?

### 12. A route to add new creatures to the database (create)

Let's define the route we just promised to set up when we said `url: "/creatures", method: "post"`. It's a `POST /creatures` route, and Rails calls this action `create`.

```ruby
#/config/routes.rb

Rails.application.routes.draw do
	root to: 'creatures#index'
	resource :creatures, only: [:index, :new, :create]
end
```

Run `rake routes` from the Terminal to see the new route that Rails created for you.

### 13. A create controller action

Let's get this data into the database! We'll need to make a `creatures#create` controller action.

```ruby
#app/controllers/creatures_controller.rb

class CreaturesController < ApplicationController

	# keep your other methods, and add:
	# create a new creature in the database
	def create
		# validate params and save them as a variable
		creature_params = params.require(:creature).permit(:name, :description)
		# create a new creature and save as an instance variable
		@creature = Creature.new(creature_params)
		# check that it saved
		if @creature.save
			# if saved, redirect to route that shows all creatures
			redirect_to "/creatures"
		end
	end
end
```

### 14. A smarter view for the new creature form


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

### 15. Show route

Right now, our app redirects to `/creatures` after a creature is made, and the new creature shows up at the bottom of the page.  Let's make a route where users can go to see a specific creature. Then we'll be able to show a creature by itself right after it's created.

First, add a `show` route.  This sets up a `GET /creatures/:id`.

```ruby
# /config/routes.rb

Rails.application.routes.draw do
	root to: 'creatures#index'
	resources :creatures, only: [:index, :new, :create, :show]
end
```

Now that we have our route, we'll add the controller action it uses.

```ruby
#app/controllers/creatures_controller.rb

class CreaturesController < ApplicationController

	# keep your other methods, and add:
	def show
		id = params[:id]
		@creature = Creature.find(id)
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


### 16. Changing the `#create` redirect

The `creatures#create` method currently redirects to `/creatures`. Again, this isn't very helpful for users who want to verify that they successfully created a creature. The best way to fix this is to have it redirect to `/creatures/:id`  instead.

```ruby
# app/controllers/creatures_controller.rb

class CreaturesController < ApplicationController

	# keep your other methods the same, and update create:
	def create
		creature_params = params.require(:creature).permit(:name, :description)
		@creature = Creature.new(creature_params)
		if @creature.save
			redirect_to "/creatures/#{creature.id}"
			# @TODO
			redirect_to @creature
		end
	end
end
```


Part III: Change a Creature with Edit (form) and Update (database) 

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

### 17. The edit route, controller action, and form

We begin with showing the edit form: this will be our server's response to a `GET /creatures/:id/edit` request from a client.  We can easily define a route to handle getting the edit page by expanding our `resources` in `routes.rb`.

```ruby
#/config/routes.rb

Rails.application.routes.draw do
	root to: 'creatures#index'
	resources :creatures, only: [:index, :new, :create, :show, :edit]
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

Go to `localhost:3000/creatures/1/edit` to see what it looks like so far.  Check the `method` and `action` of the form.

Oh no! When we go visit that part of our site, we get an error that looks like this:

	`undefined method 'creature_path' for #<#<Class:0x007fc5fc41be68>:0x007fc5fc40ea38>`

<!-- @TODO -->

![](https://media.giphy.com/media/m8eIbBdkJK7Go/giphy.gif)

The "paths" in a Rails app are related to routes. In particular `rake routes` (from the Terminal) shows shows that some routes have a path prefix listed.  These routes are associated with path methods Rails creates for us and uses behind the scenes. The format of a path method name is `prefix_path` (for example, `creatures_path`). Notice that there is no prefix of `creature`, which means Rails hasn't created a `creature_path` for us yet. 

```ruby
#/config/routes.rb

Rails.application.routes.draw do
	root to: 'creatures#index'

	resources :creatures, only: [:index, :new, :show, :create, :edit]
end
```

That's pretty much the whole shebang when comes to getting an edit page. Our previous knowledge has really come to help us understand what we need to do. We'll see this also true for the update that still needs to be handled when a user submits the form above.


### 18. Updating the database with form data

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
end
```

Run `rake routes` in the Terminal to see the newly created update routes.

In the `CreaturesController`, create an `update` action.

```ruby
# app/controllers/creatures_controller.rb

class CreaturesController < ApplicationController

	# keep your other methods and add:
	def update
		creature_id = params[:id]
		creature = Creature.find(Creature_id)

		# get updated data
		updated_attributes = params.require(:creatue).permit(:name, :description)
		# update the creature
		creature.update_attributes(updated_attributes)

		#redirect to show
		# @TODO
		#redirect_to "/creatures/#{creature_id}"
		redirect_to creature
	end
end
```

* Test your update in the broswer by editing the creature with an `id` of 1 (go to `/creatures/1/edit`).

## Part IV: Delete a Creature with Delete/Destory

### 19. Destroy 

Following a similar pattern to the above, we have Rails `resources` create a route to destroy (delete) a specific record based on its `id`.  The RESTful route it creates is `DELETE /creatures/:id`.

```ruby

#/config/routes.rb

Rails.application.routes.draw do
	root to: 'creatures#index'
	resources :creatures, only: [:index, :new, :show, :create, :edit, :update, :destroy]
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
		# show all creatures
		redirect_to "/creatures"
	end

end
```

If you were tempted to use [`Creature.delete`](http://apidock.com/rails/ActiveRecord/Base/delete/class) to delete from the database, that would be okay *in this case* because there are no relatonships or associations among resources in this app. However, get in the habit of using `creature.destroy` to avoid problems with related resources later.

Let's add a delete button in an existing view.

```html
<!-- app/views/creatures/index.html.erb -->

<% @creatures.each do |creature| %>
  <h2> <%= creature.name %> </h2>
  <p> <%= creature.description %></p>
  <%= button_to "Delete", creature, method: :delete %>
<% end %>
```

Visit `localhost:3000/` and check out the delete button HTML.  Clicking one of the delete buttons to manually test your delete feature.

At this point, we have used all the RESTful routes for creatures.  Refactor your `config/routes.rb` to use reflect that we're using all of `resources` for creatures (remove the `only:` part).

```ruby
#/config/routes.rb
Rails.application.routes.draw do
	root to: 'creatures#index'
	resources :creatures
end
```

At this point, you've created all the RESTful routes, implemented controller actions for each route, and made views for index, show, new, and edit. You've also created the model in the database and manually tested that everything works.

#CONGRATULATIONS! You have created a Bog App! Take a break, you look *Swamped*!

![Swamp Thing](http://orig11.deviantart.net/4b3a/f/2010/088/e/2/swamp_thing_by_killbabykill.jpg)
