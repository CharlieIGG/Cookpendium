# frozen_string_literal: true

recipes_array = [
  {
    'cooking_time_minutes' => 30,
    'prep_time_minutes' => 15,
    'serving_unit' => 'servings',
    'servings' => 2,
    'vegan' => true,
    'vegetarian' => true,
    'title' => 'Potato Salad',
    'description' => 'A simple and delicious recipe for potato salad, perfect for any occasion.',
    'ingredients' => [
      { 'ingredient' => 'Potatoes', 'quantity' => 1, 'unit' => 'kg' },
      { 'ingredient' => 'Onion', 'quantity' => 1, 'unit' => '' },
      { 'ingredient' => 'Vegetable broth', 'quantity' => 200, 'unit' => 'ml' },
      { 'ingredient' => 'White wine vinegar', 'quantity' => 3, 'unit' => 'tablespoons' },
      { 'ingredient' => 'Vegetable oil', 'quantity' => 4, 'unit' => 'tablespoons' },
      { 'ingredient' => 'Mustard', 'quantity' => 1, 'unit' => 'teaspoon' },
      { 'ingredient' => 'Salt', 'quantity' => nil, 'unit' => 'to taste' },
      { 'ingredient' => 'Black pepper', 'quantity' => nil, 'unit' => 'to taste' },
      { 'ingredient' => 'Chopped fresh parsley', 'quantity' => nil, 'unit' => 'for garnish' }
    ],
    'recipe_steps' => [
      {
        'description' => 'Wash and peel the potatoes. Slice into thin rounds.',
        'instruction' => 'Prepare the potatoes',
        'step_number' => 1,
        'ingredients' => [{ 'ingredient' => 'Potatoes', 'quantity' => 1, 'unit' => 'kg' }]
      },
      {
        'description' => 'Boil the potato slices in a pot of salted water until tender but still firm. Drain and let cool slightly.',
        'instruction' => 'Cook the potatoes',
        'step_number' => 2,
        'ingredients' => [{ 'ingredient' => 'Potatoes', 'quantity' => 1, 'unit' => 'kg' }]
      },
      {
        'description' => 'In a bowl, combine onion, vegetable broth, white wine vinegar, vegetable oil, and mustard. Season with salt and pepper.',
        'instruction' => 'Prepare the dressing',
        'step_number' => 3,
        'ingredients' => [
          { 'ingredient' => 'Onion', 'quantity' => 1, 'unit' => '' },
          { 'ingredient' => 'Vegetable broth', 'quantity' => 200, 'unit' => 'ml' },
          { 'ingredient' => 'White wine vinegar', 'quantity' => 3, 'unit' => 'tablespoons' },
          { 'ingredient' => 'Vegetable oil', 'quantity' => 4, 'unit' => 'tablespoons' },
          { 'ingredient' => 'Mustard', 'quantity' => 1, 'unit' => 'teaspoon' }
        ]
      },
      {
        'description' => 'Add the warm potato slices to the dressing mixture. Gently toss to ensure the potatoes are well coated with the dressing.',
        'instruction' => 'Mix potatoes with dressing',
        'step_number' => 4,
        'ingredients' => [
          { 'ingredient' => 'Potatoes', 'quantity' => 1, 'unit' => 'kg' },
          { 'ingredient' => 'Onion', 'quantity' => 1, 'unit' => '' },
          { 'ingredient' => 'Vegetable broth', 'quantity' => 200, 'unit' => 'ml' },
          { 'ingredient' => 'White wine vinegar', 'quantity' => 3, 'unit' => 'tablespoons' },
          { 'ingredient' => 'Vegetable oil', 'quantity' => 4, 'unit' => 'tablespoons' },
          { 'ingredient' => 'Mustard', 'quantity' => 1, 'unit' => 'teaspoon' }
        ]
      },
      {
        'description' => 'Allow the potato salad to sit for at least 30 minutes to allow the flavors to meld together.',
        'instruction' => 'Let the salad rest',
        'step_number' => 5,
        'ingredients' => [
          { 'ingredient' => 'Potatoes', 'quantity' => 1, 'unit' => 'kg' },
          { 'ingredient' => 'Onion', 'quantity' => 1, 'unit' => '' },
          { 'ingredient' => 'Vegetable broth', 'quantity' => 200, 'unit' => 'ml' },
          { 'ingredient' => 'White wine vinegar', 'quantity' => 3, 'unit' => 'tablespoons' },
          { 'ingredient' => 'Vegetable oil', 'quantity' => 4, 'unit' => 'tablespoons' },
          { 'ingredient' => 'Mustard', 'quantity' => 1, 'unit' => 'teaspoon' }
        ]
      },
      {
        'description' => 'Garnish with chopped fresh parsley just before serving.',
        'instruction' => 'Garnish with parsley',
        'step_number' => 6,
        'ingredients' => [{ 'ingredient' => 'Chopped fresh parsley', 'quantity' => nil, 'unit' => 'for garnish' }]
      }
    ],
    'locale' => 'en'
  },
  {
    'cooking_time_minutes' => 30,
    'prep_time_minutes' => 15,
    'serving_unit' => 'cookies',
    'servings' => 30,
    'vegan' => false,
    'vegetarian' => true,
    'title' => 'Chocolate Chip Cookies',
    'description' => 'Classic homemade chocolate chip cookies that are soft, chewy, and full of chocolatey goodness.',
    'ingredients' => [
      { 'ingredient' => 'All-purpose flour', 'quantity' => 2.25, 'unit' => 'cups' },
      { 'ingredient' => 'Baking soda', 'quantity' => 1, 'unit' => 'teaspoon' },
      { 'ingredient' => 'Salt', 'quantity' => 0.5, 'unit' => 'teaspoon' },
      { 'ingredient' => 'Unsalted butter', 'quantity' => 1, 'unit' => 'cup' },
      { 'ingredient' => 'Granulated sugar', 'quantity' => 0.75, 'unit' => 'cup' },
      { 'ingredient' => 'Brown sugar', 'quantity' => 0.75, 'unit' => 'cup' },
      { 'ingredient' => 'Vanilla extract', 'quantity' => 1, 'unit' => 'teaspoon' },
      { 'ingredient' => 'Egg', 'quantity' => 2, 'unit' => '' },
      { 'ingredient' => 'Semi-sweet chocolate chips', 'quantity' => 2, 'unit' => 'cups' }
    ],
    'recipe_steps' => [
      {
        'description' => 'Preheat the oven to 375°F (190°C). Line baking sheets with parchment paper.',
        'instruction' => 'Prepare the oven and baking sheets',
        'step_number' => 1,
        'ingredients' => []
      },
      {
        'description' => 'In a medium bowl, whisk together the flour, baking soda, and salt. Set aside.',
        'instruction' => 'Combine dry ingredients',
        'step_number' => 2,
        'ingredients' => [
          { 'ingredient' => 'All-purpose flour', 'quantity' => 2.25, 'unit' => 'cups' },
          { 'ingredient' => 'Baking soda', 'quantity' => 1, 'unit' => 'teaspoon' },
          { 'ingredient' => 'Salt', 'quantity' => 0.5, 'unit' => 'teaspoon' }
        ]
      },
      {
        'description' => 'In a large bowl, cream together the butter, granulated sugar, and brown sugar until light and fluffy.',
        'instruction' => 'Cream the butter and sugars',
        'step_number' => 3,
        'ingredients' => [
          { 'ingredient' => 'Unsalted butter', 'quantity' => 1, 'unit' => 'cup' },
          { 'ingredient' => 'Granulated sugar', 'quantity' => 0.75, 'unit' => 'cup' },
          { 'ingredient' => 'Brown sugar', 'quantity' => 0.75, 'unit' => 'cup' }
        ]
      },
      {
        'description' => 'Beat in the vanilla extract and eggs, one at a time, until well combined.',
        'instruction' => 'Add vanilla extract and eggs',
        'step_number' => 4,
        'ingredients' => [
          { 'ingredient' => 'Vanilla extract', 'quantity' => 1, 'unit' => 'teaspoon' },
          { 'ingredient' => 'Egg', 'quantity' => 2, 'unit' => '' }
        ]
      },
      {
        'description' => 'Gradually add the dry ingredients to the wet ingredients, mixing until just combined.',
        'instruction' => 'Combine wet and dry ingredients',
        'step_number' => 5,
        'ingredients' => [
          { 'ingredient' => 'All-purpose flour', 'quantity' => 2.25, 'unit' => 'cups' },
          { 'ingredient' => 'Baking soda', 'quantity' => 1, 'unit' => 'teaspoon' },
          { 'ingredient' => 'Salt', 'quantity' => 0.5, 'unit' => 'teaspoon' }
        ]
      },
      {
        'description' => 'Stir in the chocolate chips until evenly distributed throughout the dough.',
        'instruction' => 'Add chocolate chips',
        'step_number' => 6,
        'ingredients' => [{ 'ingredient' => 'Semi-sweet chocolate chips', 'quantity' => 2, 'unit' => 'cups' }]
      },
      {
        'description' => 'Drop rounded tablespoons of dough onto the prepared baking sheets, spacing them about 2 inches apart.',
        'instruction' => 'Form and place the cookie dough',
        'step_number' => 7,
        'ingredients' => []
      },
      {
        'description' => 'Bake for 9-11 minutes, or until the edges are golden brown. Remove from the oven and let cool on the baking sheets for 5 minutes.',
        'instruction' => 'Bake and cool the cookies',
        'step_number' => 8,
        'ingredients' => []
      },
      {
        'description' => 'Transfer the cookies to a wire rack to cool completely. Enjoy!',
        'instruction' => 'Cool and enjoy the cookies',
        'step_number' => 9,
        'ingredients' => []
      }
    ],
    'locale' => 'en'
  },
  {
    'cooking_time_minutes' => 30,
    'prep_time_minutes' => 15,
    'serving_unit' => 'servings',
    'servings' => 2,
    'vegan' => false,
    'vegetarian' => false,
    'title' => 'Chicken Alfredo',
    'description' => 'A creamy and flavorful pasta dish made with tender chicken and a rich Alfredo sauce.',
    'ingredients' => [
      { 'ingredient' => 'Chicken breast', 'quantity' => 2, 'unit' => '' },
      { 'ingredient' => 'Fettuccine pasta', 'quantity' => 8, 'unit' => 'oz' },
      { 'ingredient' => 'Butter', 'quantity' => 4, 'unit' => 'tablespoons' },
      { 'ingredient' => 'Garlic', 'quantity' => 3, 'unit' => 'cloves' },
      { 'ingredient' => 'Heavy cream', 'quantity' => 1, 'unit' => 'cup' },
      { 'ingredient' => 'Parmesan cheese', 'quantity' => 1, 'unit' => 'cup' },
      { 'ingredient' => 'Salt', 'quantity' => nil, 'unit' => 'to taste' },
      { 'ingredient' => 'Black pepper', 'quantity' => nil, 'unit' => 'to taste' },
      { 'ingredient' => 'Fresh parsley', 'quantity' => nil, 'unit' => 'for garnish' }
    ],
    'recipe_steps' => [
      {
        'description' => 'Cook the fettuccine pasta according to package instructions. Drain and set aside.',
        'instruction' => 'Cook the pasta',
        'step_number' => 1,
        'ingredients' => [{ 'ingredient' => 'Fettuccine pasta', 'quantity' => 8, 'unit' => 'oz' }]
      },
      {
        'description' => 'Season the chicken breasts with salt and pepper. In a large skillet, melt the butter over medium heat.',
        'instruction' => 'Prepare the chicken',
        'step_number' => 2,
        'ingredients' => [
          { 'ingredient' => 'Chicken breast', 'quantity' => 2, 'unit' => '' },
          { 'ingredient' => 'Butter', 'quantity' => 4, 'unit' => 'tablespoons' },
          { 'ingredient' => 'Salt', 'quantity' => nil, 'unit' => 'to taste' },
          { 'ingredient' => 'Black pepper', 'quantity' => nil, 'unit' => 'to taste' }
        ]
      },
      {
        'description' => 'Add the chicken breasts to the skillet and cook until browned and cooked through, about 6-8 minutes per side. Remove from the skillet and let rest for a few minutes. Slice the chicken into thin strips.',
        'instruction' => 'Cook and slice the chicken',
        'step_number' => 3,
        'ingredients' => [{ 'ingredient' => 'Chicken breast', 'quantity' => 2, 'unit' => '' }]
      },
      {
        'description' => 'In the same skillet, add the minced garlic and cook until fragrant, about 1 minute.',
        'instruction' => 'Cook the garlic',
        'step_number' => 4,
        'ingredients' => [{ 'ingredient' => 'Garlic', 'quantity' => 3, 'unit' => 'cloves' }]
      },
      {
        'description' => 'Reduce the heat to low and add the heavy cream and Parmesan cheese to the skillet. Stir until the cheese has melted and the sauce is smooth and creamy.',
        'instruction' => 'Make the Alfredo sauce',
        'step_number' => 5,
        'ingredients' => [
          { 'ingredient' => 'Heavy cream', 'quantity' => 1, 'unit' => 'cup' },
          { 'ingredient' => 'Parmesan cheese', 'quantity' => 1, 'unit' => 'cup' }
        ]
      },
      {
        'description' => 'Add the cooked fettuccine pasta and sliced chicken to the skillet. Toss until the pasta and chicken are coated with the sauce.',
        'instruction' => 'Combine pasta, chicken, and sauce',
        'step_number' => 6,
        'ingredients' => [
          { 'ingredient' => 'Fettuccine pasta', 'quantity' => 8, 'unit' => 'oz' },
          { 'ingredient' => 'Chicken breast', 'quantity' => 2, 'unit' => '' }
        ]
      },
      {
        'description' => 'Season with salt and pepper to taste. Garnish with fresh parsley before serving.',
        'instruction' => 'Season and garnish',
        'step_number' => 7,
        'ingredients' => [
          { 'ingredient' => 'Salt', 'quantity' => nil, 'unit' => 'to taste' },
          { 'ingredient' => 'Black pepper', 'quantity' => nil, 'unit' => 'to taste' },
          { 'ingredient' => 'Fresh parsley', 'quantity' => nil, 'unit' => 'for garnish' }
        ]
      }
    ],
    'locale' => 'en'
  },
  {
    'cooking_time_minutes' => 30,
    'prep_time_minutes' => 15,
    'serving_unit' => 'servings',
    'servings' => 4,
    'vegan' => false,
    'vegetarian' => true,
    'title' => 'Caprese Salad',
    'description' => 'A refreshing and colorful salad made with ripe tomatoes, fresh mozzarella, and fragrant basil.',
    'ingredients' => [
      { 'ingredient' => 'Ripe tomatoes', 'quantity' => 4, 'unit' => '' },
      { 'ingredient' => 'Fresh mozzarella', 'quantity' => 8, 'unit' => 'oz' },
      { 'ingredient' => 'Fresh basil leaves', 'quantity' => 1, 'unit' => 'cup' },
      { 'ingredient' => 'Extra virgin olive oil', 'quantity' => 2, 'unit' => 'tablespoons' },
      { 'ingredient' => 'Balsamic vinegar', 'quantity' => 2, 'unit' => 'tablespoons' },
      { 'ingredient' => 'Salt', 'quantity' => nil, 'unit' => 'to taste' },
      { 'ingredient' => 'Black pepper', 'quantity' => nil, 'unit' => 'to taste' }
    ],
    'recipe_steps' => [
      {
        'description' => 'Slice the tomatoes and fresh mozzarella into 1/4-inch thick slices.',
        'instruction' => 'Prepare the tomatoes and mozzarella',
        'step_number' => 1,
        'ingredients' => [
          { 'ingredient' => 'Ripe tomatoes', 'quantity' => 4, 'unit' => '' },
          { 'ingredient' => 'Fresh mozzarella', 'quantity' => 8, 'unit' => 'oz' }
        ]
      },
      {
        'description' => 'Arrange the tomato and mozzarella slices on a serving platter, alternating between the two.',
        'instruction' => 'Arrange the salad',
        'step_number' => 2,
        'ingredients' => [
          { 'ingredient' => 'Ripe tomatoes', 'quantity' => 4, 'unit' => '' },
          { 'ingredient' => 'Fresh mozzarella', 'quantity' => 8, 'unit' => 'oz' }
        ]
      },
      {
        'description' => 'Tuck fresh basil leaves in between the tomato and mozzarella slices.',
        'instruction' => 'Add fresh basil leaves',
        'step_number' => 3,
        'ingredients' => [{ 'ingredient' => 'Fresh basil leaves', 'quantity' => 1, 'unit' => 'cup' }]
      },
      {
        'description' => 'Drizzle the salad with extra virgin olive oil and balsamic vinegar.',
        'instruction' => 'Dress the salad',
        'step_number' => 4,
        'ingredients' => [
          { 'ingredient' => 'Extra virgin olive oil', 'quantity' => 2, 'unit' => 'tablespoons' },
          { 'ingredient' => 'Balsamic vinegar', 'quantity' => 2, 'unit' => 'tablespoons' }
        ]
      },
      {
        'description' => 'Season with salt and pepper to taste. Serve immediately.',
        'instruction' => 'Season and serve',
        'step_number' => 5,
        'ingredients' => [
          { 'ingredient' => 'Salt', 'quantity' => nil, 'unit' => 'to taste' },
          { 'ingredient' => 'Black pepper', 'quantity' => nil, 'unit' => 'to taste' }
        ]
      }
    ],
    'locale' => 'en'
  },
  {
    'cooking_time_minutes' => 30,
    'prep_time_minutes' => 15,
    'serving_unit' => 'pizza',
    'servings' => 1,
    'vegan' => false,
    'vegetarian' => true,
    'title' => 'Margarita Pizza',
    'description' => 'A classic Italian pizza topped with fresh tomatoes, mozzarella cheese, and fragrant basil leaves.',
    'ingredients' => [
      { 'ingredient' => 'Pizza dough', 'quantity' => 1, 'unit' => '' },
      { 'ingredient' => 'Ripe tomatoes', 'quantity' => 4, 'unit' => '' },
      { 'ingredient' => 'Fresh mozzarella', 'quantity' => 8, 'unit' => 'oz' },
      { 'ingredient' => 'Fresh basil leaves', 'quantity' => 1, 'unit' => 'cup' },
      { 'ingredient' => 'Extra virgin olive oil', 'quantity' => 2, 'unit' => 'tablespoons' },
      { 'ingredient' => 'Salt', 'quantity' => nil, 'unit' => 'to taste' },
      { 'ingredient' => 'Black pepper', 'quantity' => nil, 'unit' => 'to taste' }
    ],
    'recipe_steps' => [
      {
        'description' => 'Preheat the oven to the highest temperature setting (usually around 500°F or 260°C).',
        'instruction' => 'Preheat the oven',
        'step_number' => 1,
        'ingredients' => []
      },
      {
        'description' => 'Roll out the pizza dough into a round shape on a floured surface.',
        'instruction' => 'Roll out the dough',
        'step_number' => 2,
        'ingredients' => [{ 'ingredient' => 'Pizza dough', 'quantity' => 1, 'unit' => '' }]
      },
      {
        'description' => 'Transfer the rolled-out dough to a baking sheet or pizza stone.',
        'instruction' => 'Transfer the dough',
        'step_number' => 3,
        'ingredients' => []
      },
      {
        'description' => 'Slice the tomatoes and fresh mozzarella into 1/4-inch thick slices.',
        'instruction' => 'Prepare the tomatoes and mozzarella',
        'step_number' => 4,
        'ingredients' => [
          { 'ingredient' => 'Ripe tomatoes', 'quantity' => 4, 'unit' => '' },
          { 'ingredient' => 'Fresh mozzarella', 'quantity' => 8, 'unit' => 'oz' }
        ]
      },
      {
        'description' => 'Arrange the tomato and mozzarella slices on top of the pizza dough, leaving a border around the edges.',
        'instruction' => 'Arrange the toppings',
        'step_number' => 5,
        'ingredients' => [
          { 'ingredient' => 'Ripe tomatoes', 'quantity' => 4, 'unit' => '' },
          { 'ingredient' => 'Fresh mozzarella', 'quantity' => 8, 'unit' => 'oz' }
        ]
      },
      {
        'description' => 'Tear the fresh basil leaves into small pieces and scatter them over the tomatoes and mozzarella.',
        'instruction' => 'Add fresh basil leaves',
        'step_number' => 6,
        'ingredients' => [{ 'ingredient' => 'Fresh basil leaves', 'quantity' => 1, 'unit' => 'cup' }]
      },
      {
        'description' => 'Drizzle the pizza with extra virgin olive oil. Season with salt and pepper to taste.',
        'instruction' => 'Dress the pizza',
        'step_number' => 7,
        'ingredients' => [
          { 'ingredient' => 'Extra virgin olive oil', 'quantity' => 2, 'unit' => 'tablespoons' },
          { 'ingredient' => 'Salt', 'quantity' => nil, 'unit' => 'to taste' },
          { 'ingredient' => 'Black pepper', 'quantity' => nil, 'unit' => 'to taste' }
        ]
      },
      {
        'description' => 'Bake the pizza in the preheated oven for about 10-12 minutes, or until the crust is golden brown and the cheese is melted and bubbly.',
        'instruction' => 'Bake the pizza',
        'step_number' => 8,
        'ingredients' => []
      },
      {
        'description' => 'Remove the pizza from the oven and let it cool for a few minutes. Slice and serve.',
        'instruction' => 'Cool and serve the pizza',
        'step_number' => 9,
        'ingredients' => []
      }
    ],
    'locale' => 'en'
  },
  {
    'cooking_time_minutes' => 30,
    'prep_time_minutes' => 15,
    'serving_unit' => 'servings',
    'servings' => 4,
    'vegan' => false,
    'vegetarian' => false,
    'title' => 'Chicken Stir-Fry',
    'description' => 'A quick and easy stir-fry recipe with tender chicken, colorful vegetables, and a flavorful sauce.',
    'ingredients' => [
      { 'ingredient' => 'Chicken breast', 'quantity' => 2, 'unit' => '' },
      { 'ingredient' => 'Broccoli florets', 'quantity' => 2, 'unit' => 'cups' },
      { 'ingredient' => 'Bell peppers', 'quantity' => 2, 'unit' => '' },
      { 'ingredient' => 'Carrots', 'quantity' => 2, 'unit' => '' },
      { 'ingredient' => 'Soy sauce', 'quantity' => 0.25, 'unit' => 'cup' },
      { 'ingredient' => 'Honey', 'quantity' => 2, 'unit' => 'tablespoons' },
      { 'ingredient' => 'Garlic', 'quantity' => 3, 'unit' => 'cloves' },
      { 'ingredient' => 'Ginger', 'quantity' => 1, 'unit' => 'inch' },
      { 'ingredient' => 'Cornstarch', 'quantity' => 1, 'unit' => 'tablespoon' },
      { 'ingredient' => 'Vegetable oil', 'quantity' => 2, 'unit' => 'tablespoons' },
      { 'ingredient' => 'Salt', 'quantity' => nil, 'unit' => 'to taste' },
      { 'ingredient' => 'Black pepper', 'quantity' => nil, 'unit' => 'to taste' },
      { 'ingredient' => 'Cooked rice', 'quantity' => nil, 'unit' => 'for serving' }
    ],
    'recipe_steps' => [
      {
        'description' => 'Slice the chicken breast into thin strips. In a small bowl, whisk together the soy sauce, honey, minced garlic, grated ginger, and cornstarch.',
        'instruction' => 'Prepare the chicken and sauce',
        'step_number' => 1,
        'ingredients' => [
          { 'ingredient' => 'Chicken breast', 'quantity' => 2, 'unit' => '' },
          { 'ingredient' => 'Soy sauce', 'quantity' => 0.25, 'unit' => 'cup' },
          { 'ingredient' => 'Honey', 'quantity' => 2, 'unit' => 'tablespoons' },
          { 'ingredient' => 'Garlic', 'quantity' => 3, 'unit' => 'cloves' },
          { 'ingredient' => 'Ginger', 'quantity' => 1, 'unit' => 'inch' },
          { 'ingredient' => 'Cornstarch', 'quantity' => 1, 'unit' => 'tablespoon' }
        ]
      },
      {
        'description' => 'Heat the vegetable oil in a large skillet or wok over medium-high heat. Add the chicken and cook until browned and cooked through, about 5-6 minutes. Remove the chicken from the skillet and set aside.',
        'instruction' => 'Cook the chicken',
        'step_number' => 2,
        'ingredients' => [
          { 'ingredient' => 'Chicken breast', 'quantity' => 2, 'unit' => '' },
          { 'ingredient' => 'Vegetable oil', 'quantity' => 2, 'unit' => 'tablespoons' }
        ]
      },
      {
        'description' => 'In the same skillet, add the broccoli florets, sliced bell peppers, and sliced carrots. Cook until the vegetables are crisp-tender, about 4-5 minutes.',
        'instruction' => 'Cook the vegetables',
        'step_number' => 3,
        'ingredients' => [
          { 'ingredient' => 'Broccoli florets', 'quantity' => 2, 'unit' => 'cups' },
          { 'ingredient' => 'Bell peppers', 'quantity' => 2, 'unit' => '' },
          { 'ingredient' => 'Carrots', 'quantity' => 2, 'unit' => '' }
        ]
      },
      {
        'description' => 'Return the cooked chicken to the skillet. Pour the sauce over the chicken and vegetables. Stir well to coat everything in the sauce.',
        'instruction' => 'Add the sauce',
        'step_number' => 4,
        'ingredients' => [
          { 'ingredient' => 'Chicken breast', 'quantity' => 2, 'unit' => '' },
          { 'ingredient' => 'Broccoli florets', 'quantity' => 2, 'unit' => 'cups' },
          { 'ingredient' => 'Bell peppers', 'quantity' => 2, 'unit' => '' },
          { 'ingredient' => 'Carrots', 'quantity' => 2, 'unit' => '' },
          { 'ingredient' => 'Soy sauce', 'quantity' => 0.25, 'unit' => 'cup' },
          { 'ingredient' => 'Honey', 'quantity' => 2, 'unit' => 'tablespoons' },
          { 'ingredient' => 'Garlic', 'quantity' => 3, 'unit' => 'cloves' },
          { 'ingredient' => 'Ginger', 'quantity' => 1, 'unit' => 'inch' },
          { 'ingredient' => 'Cornstarch', 'quantity' => 1, 'unit' => 'tablespoon' }
        ]
      },
      {
        'description' => 'Cook for an additional 2-3 minutes, or until the sauce has thickened and the chicken and vegetables are coated.',
        'instruction' => 'Thicken the sauce',
        'step_number' => 5,
        'ingredients' => []
      },
      {
        'description' => 'Season with salt and black pepper to taste. Serve the chicken stir-fry over cooked rice.',
        'instruction' => 'Season and serve',
        'step_number' => 6,
        'ingredients' => [
          { 'ingredient' => 'Salt', 'quantity' => nil, 'unit' => 'to taste' },
          { 'ingredient' => 'Black pepper', 'quantity' => nil, 'unit' => 'to taste' },
          { 'ingredient' => 'Cooked rice', 'quantity' => nil, 'unit' => 'for serving' }
        ]
      }
    ],
    'locale' => 'en'
  }
]
recipes_array.each do |recipe|
  puts "importing #{recipe['title']}..."
  RecipeImporter::Importer.new(recipe).import
end
