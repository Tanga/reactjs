@Todo = React.createClass
  getInitialState: ->
    todos: ["First Thing", "Second Thing", "Third Thing"]

  handleAddNew: (event) ->
    this.setState({todos: this.state.todos.concat("New Thing")})

  render: ->
    items = this.state.todos.map (t) -> `<li>{t}</li>`
    `<div>
      <div>
        This will be a todo list!
        There are {items.length} items in the list.
      </div>
      <ul>
        {items}
      </ul>
      <button onClick={this.handleAddNew}>Add New</button>
     </div>`
