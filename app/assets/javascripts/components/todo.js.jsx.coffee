@Todo = React.createClass
  getInitialState: ->
    todos: ["First Thing", "Second Thing", "Third Thing"]

  handleAddNew: (item) ->
    this.setState({todos: this.state.todos.concat(item)})

  handleUpdate: (oldTodo, newTodo) ->
    t = this.state.todos
    index = t.indexOf(oldTodo)
    if index > -1
      if newTodo
        t.splice(index, 1, newTodo)
      else
        t.splice(index, 1)
      this.setState({todos: t})

  render: ->
    count = this.state.todos.length
    `<div>
       <TodoSummary count={count} />
       <TodoList todos={this.state.todos} update={this.handleUpdate} />
       <TodoEntry handleEntry={this.handleAddNew} label="Add New" />
     </div>`

@TodoSummary = React.createClass
  render: ->
    `<div>
      This will be a todo list!
      There are <b>{this.props.count}</b> items in the list.
    </div>`

@TodoList = React.createClass
  render: ->
    self = this
    items = this.props.todos.map (t) ->
      `<TodoItem update={self.props.update} item={t} />`
    `<ul className='list-unstyled' >{items}</ul>`

@TodoItem = React.createClass
  getInitialState: ->
    {showEdit: false }
  remove: -> this.props.update(this.props.item)
  edit:   -> this.setState(showEdit: true)
  edited: (newValue) ->
      this.props.update(this.props.item, newValue)
      this.setState(showEdit: false)
  render: ->
    `<li>
      <a className='btn' onClick={this.remove}>X</a>
      <a className='btn' onClick={this.edit}>Edit</a>
      {this.state.showEdit ?
       <TodoEntry label="Edit" handleEntry={this.edited} value={this.props.item} /> :
       this.props.item}
     </li>`

@TodoEntry = React.createClass
  handleEntry: (e) ->
    e.preventDefault()
    dom = this.refs['todo'].getDOMNode()
    this.props.handleEntry(dom.value)
    dom.value = ''
  render: ->
    `<form className='todo' onSubmit={this.handleEntry}>
       <input required ref='todo' defaultValue={this.props.value} />
       <button>{this.props.label}</button>
     </form>`
