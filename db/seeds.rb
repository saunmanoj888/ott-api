# Create User

admin = User.create(email: 'admin@example.com', password: 'qwerty', first_name: 'John', last_name: 'Doe')
user = User.create(email: 'user@example.com', password: 'qwerty', first_name: 'User', last_name: 'Doe')

# Set Admin role
admin.add_role :admin

#Create Movie

movie = Movie.create(title: 'Shaolin Soccer', description: 'Comedy', release_date: '12-07-2001', budget: 123333)

# Create a Person
person1 = Person.create(name: 'Stephen Chow')
person2 = Person.create(name: 'Zhao Wei')

# add cast crew

cast1 = movie.cast_crews.new(person: person1, designation: 'Actor', character: 'Mighty Stee')
cast1.save

crew1 = movie.cast_crews.new(person: person1, designation: 'Director')
crew1.save

cast2 = movie.cast_crews.new(person: person2, designation: 'Actress', character: 'Mui')
cast2.save
