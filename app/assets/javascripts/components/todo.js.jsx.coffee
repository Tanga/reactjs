@Todo = React.createClass
  getInitialState: ->
    todos: ["First Thing", "Second Thing", "Third Thing"]

  handleAddNew: ->
    this.setState({todos: this.state.todos.concat("New Thing")})

  render: ->
    count = this.state.todos.length
    `<div>
       <div>
         This will be a todo list!
         There are <b>{count}</b> items in the list.
       </div>
       <TodoList todos={this.state.todos}/>
       <button onClick={this.handleAddNew}>Add New</button>
     </div>`

@TodoList = React.createClass
  render: ->
    items = this.props.todos.map (t) -> `<li>{t}</li>`
    `<ul>{items}</ul>`
