Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/game' => "longest_word#ask"
  get '/score' => "longest_word#result"
end
