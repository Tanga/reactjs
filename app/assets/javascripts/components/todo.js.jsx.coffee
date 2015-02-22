# TODO figure out how to do better models, assuming that's the right
# thing to do.
@Todo = React.createClass
  getInitialState: ->
    todos: ["Server First Thing", "Server Second Thing", "Server Third Thing"]

  componentDidMount: ->
    # On the client, let's fetch some questions and make them todo's.
    $.get 'https://api.tanga.com/personalizer/v1/interviews?interview_id=2&session_id=1', (interview) =>
      questions = interview.questions.map (question) -> question.question_text
      @handleAddNew(questions)

  handleAddNew: (item) ->
    @setState(todos: @state.todos.concat(item))

  # TODO better way to do this?
  handleUpdate: (oldTodo, newTodo) ->
    t = @state.todos
    index = t.indexOf(oldTodo)
    if index > -1
      if newTodo
        t.splice(index, 1, newTodo)
      else
        t.splice(index, 1)
      @setState(todos: t)

  render: ->
    `<div className='todo'>
       <TodoSummary todos={this.state.todos} />
       <TodoList todos={this.state.todos} update={this.handleUpdate} />
       <TodoEntry handleEntry={this.handleAddNew}>
         <button>Add</button>
       </TodoEntry>
     </div>`

@TodoSummary = React.createClass
  render: ->
    `<div>This is a TODO list! There are <b>{this.props.todos.length}</b> items.</div>`

@TodoList = React.createClass
  items: -> @props.todos.map (t) =>
    TodoItem(update: @props.update, item: t)
  render: ->
    `<div>{this.items()}</div>`

@TodoItem = React.createClass
  getInitialState: -> {showEdit: false}
  toggleEdit: -> @setState(showEdit: !@state.showEdit)
  remove: -> @props.update(@props.item)
  update: (newValue) ->
      @props.update(this.props.item, newValue)
      @toggleEdit()
  editForm: ->
    `<div>
      <TodoEntry handleEntry={this.update} todo={this.props.item} />
      <a className='cancel' onClick={this.toggleEdit}>Cancel</a>
    </div>`
  displayItem: -> `<div className='item'>{this.props.item}</div>`
  render: ->
    `<div className='todo-line'>
       <div className='edit-buttons'>
         <a onClick={this.remove}>X</a>
         <a onClick={this.toggleEdit}>Edit</a>
       </div>
       <div className='todo-display'>
         {this.state.showEdit ? this.editForm() : this.displayItem() }
       </div>
     </div>`

@TodoEntry = React.createClass
  getInitialState: -> {todo: @props.todo}
  mixins: [React.addons.LinkedStateMixin] # For 2 way data binding
  handleEntry: (e) ->
    e.preventDefault() # meh
    @props.handleEntry(@state.todo)
    @setState(todo: '')
  render: ->
    `<form className='todo-entry' onSubmit={this.handleEntry}>
       <input onBlur={this.handleEntry} required valueLink={this.linkState('todo')} autoFocus />
       {this.props.children}
     </form>`
