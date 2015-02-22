@Todo = React.createClass
  getInitialState: ->
    todos: ["First Thing", "Second Thing", "Third Thing"]

  handleAddNew: (item) ->
    this.setState({todos: this.state.todos.concat(item)})

  handleRemove: (item) ->
    t = this.state.todos
    index = t.indexOf(item)
    if index > -1
      t.splice(index, 1)
      this.setState({todos: t})

  render: ->
    count = this.state.todos.length
    `<div>
       <TodoSummary count={count} />
       <TodoList todos={this.state.todos} remove={this.handleRemove} />
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
    items = this.props.todos.map (t) -> `<TodoItem item={t} remove={self.props.remove} />`
    `<ul className='list-unstyled' >{items}</ul>`

@TodoItem = React.createClass
  remove: -> this.props.remove(this.props.item)
  render: ->
    `<li>
      <a className='btn' onClick={this.remove}>X</a>
      {this.props.item}
     </li>`

@TodoEntry = React.createClass
  handleEntry: (e) ->
    e.preventDefault()
    dom = this.refs['todo'].getDOMNode()
    this.props.handleEntry(dom.value)
    dom.value = ''
  render: ->
    `<form onSubmit={this.handleEntry}>
       <input required ref='todo' />
       <button>{this.props.label}</button>
     </form>`
