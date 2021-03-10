# Create User

admin = User.create(email: 'admin@example.com', password: 'qwerty', first_name: 'John', last_name: 'Doe', is_admin: true)
user = User.create(email: 'user@example.com', password: 'qwerty', first_name: 'User', last_name: 'Doe')

#Create Movie

movie = Movie.create(title: 'Shaolin Soccer', description: 'Comedy', release_date: '12-07-2001', budget: 123333)

# Create a Person
person1 = Person.create(name: 'Stephen Chow')
person2 = Person.create(name: 'Zhao Wei')

# Create Profession
job1 = Profession.create(designation: 'Actor')
job2 = Profession.create(designation: 'Director')
job3 = Profession.create(designation: 'Actress')

# add cast crew

cast1 = movie.cast_crews.new(person: person1, profession: job1, character: 'Mighty Stee')
cast1.save

crew1 = movie.cast_crews.new(person: person1, profession: job2)
crew1.save

cast2 = movie.cast_crews.new(person: person2, profession: job3, character: 'Mui')
cast2.save
