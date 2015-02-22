@Interviews = React.createClass
  getInitialState: ->
    loading: true
    interview: {questions: []}
    currentIndex: 0,
    answers: []

  question:      -> @state.interview.questions[@state.currentIndex]
  questionCount: -> @state.interview.questions.length
  currentIndex:  -> @state.currentIndex
  finished:      -> @currentIndex() >= @questionCount()

  onAnswer: (choice) ->
    @setState(answers: @state.answers.concat(choice))
    @setState(currentIndex: @state.currentIndex + 1)
    console.log "You answered " + JSON.stringify(choice)

  componentDidMount: ->
    setTimeout((=> # Artificial timeout
      $.get 'https://api.tanga.com/personalizer/v1/interviews?interview_id=2&session_id=1', (interview) =>
        console.log interview
        interview.questions = interview.questions.splice(14, 20) # limit during testing
        @setState(interview: interview, loading: false)
    ), 500)

  render: ->
    if @state.loading
      `<div>Loading...</div>`
    else
      `<div>
         <div className='logo'><img src='/assets/bellechic-logo.png' /></div>
         <div className='get-to-know'> Let's get to know each other better</div>
         <div className='question-container'>
           <ProgressBar progress={this.currentIndex()} total={this.questionCount()} />
           <div className='questions'>
             <Question answers={this.state.answers} finished={this.finished()} onAnswer={this.onAnswer} question={this.question()} />
           </div>
         </div>
       </div>`

ProgressBar = React.createClass
  percent: -> Math.round((this.props.progress / this.props.total) * 100)
  percentDescription: -> @percent() + "%"
  text: -> "#{@percentDescription()} Complete" if @percent() > 0
  width: -> {width: @percentDescription()}
  render: ->
    `<div className='bellechic-progress'>
        <div className="progress">
          <div className="progress-bar" role="progressbar" style={this.width()}>
            <span>{this.text()}</span>
          </div>
        </div>
      </div>`

Question = React.createClass
  questionView: ->
    `<div className='question'>
       <div className='question-text'>{this.props.question.question_text}</div>
       <Choices onAnswer={this.props.onAnswer} question={this.props.question} />
     </div>`
  finishedView: ->
    `<div className='question'>
       <h4>Thanks Dude</h4>
       <p> Your Answers: </p>
       <pre>{JSON.stringify(this.props.answers)}</pre>
     </div>
    `
  render: -> if @props.finished then @finishedView() else @questionView()

Choices = React.createClass
  component: ->
    switch(@props.question.type)
      when 'button-choices'
        @props.question.choices.map (choice) =>
          ButtonChoice(onAnswer: @props.onAnswer, choice: choice)
      when 'image-choice'
        @props.question.choices.map (choice) =>
          ImageChoice(onAnswer: @props.onAnswer, choice: choice)
      when 'text-answer'
        TextAnswer(onAnswer: @props.onAnswer, question: @props.question)

  render: -> `<div className='questions'>{this.component()}</div>`

TextAnswer = React.createClass
  getInitialState: -> {answer: ''}
  mixins: [React.addons.LinkedStateMixin] # For 2 way data binding
  onAnswer: (e) ->
    e.preventDefault() # meh
    this.props.onAnswer(@state.answer)
  render: ->
    `<form className='text-answer' onSubmit={this.onAnswer}>
       <input valueLink={this.linkState('answer')} autoFocus required />
     </form>`

ButtonChoice = React.createClass
  onAnswer: ->
    this.props.onAnswer(this.props.choice)
  render: ->
    `<div className='button'><a className='btn btn-default' onClick={this.onAnswer}>{this.props.choice.value}</a></div>`

ImageChoice = React.createClass
  onAnswer: ->
    this.props.onAnswer(this.props.choice)
  url: ->
    # Placeholder until the dropbox images get fixed.
    images =
      ["https://scontent-sea.xx.fbcdn.net/hphotos-xap1/v/t1.0-9/1978779_10152284403327938_866586778_n.jpg?oh=6e65a075bf13d078c0e7873944781822&oe=5592BA08",
       "https://scontent-sea.xx.fbcdn.net/hphotos-xpa1/v/t1.0-9/10360337_10152467102527938_4679615289034742209_n.jpg?oh=48ef9dabd4dfc2838182547788e06523&oe=554FE739",
       "https://fbcdn-sphotos-h-a.akamaihd.net/hphotos-ak-xap1/v/t1.0-9/10422483_10154934772010145_7427866435822511391_n.jpg?oh=b04c93b64ec5764f0680834c62f36fd1&oe=554D8A55&__gda__=1434426624_3211134d5f3ffa58ef3f1bb5fd3b5fa2",
       "https://fbcdn-sphotos-g-a.akamaihd.net/hphotos-ak-xpa1/v/t1.0-9/1549467_10152215305037938_408102343_n.jpg?oh=ead6d4dbeb066fc98a9913c03b944953&oe=5580DC55&__gda__=1435365006_9c322d90ab83cbb188021e8daa101b31",
       "https://scontent-sea.xx.fbcdn.net/hphotos-xfp1/v/t1.0-9/1146573_10151813062782938_1337287877_n.jpg?oh=200ecb05ecfc27d1f7e79fb39b7c71ac&oe=5556B964"]
     images[Math.floor(Math.random()*images.length)]
  render: ->
    `<div className='image-choice'>
       <img onClick={this.onAnswer} src={this.url()} />
     </div>`
