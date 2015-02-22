Rails.application.routes.draw do
  root to: 'welcome#index'
  get 'questions' => 'welcome#questions'
end
