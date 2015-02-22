@Todo = React.createClass
  getInitialState: ->
    todos: ["First Thing", "Second Thing", "Third Thing"]

  handleAddNew: (event) ->
    this.setState({todos: this.state.todos.concat("New Thing")})

  render: ->
    items = this.state.todos.map (t) -> `<li key={t.id}>{t}</li>`
    `<div>
      <div>This will be a todo list!</div>
      <ul>
        {items}
      </ul>
      <button onClick={this.handleAddNew}>Add New</button>
     </div>`
