before ->
  $('body').html('<div data-formrenderer />')

describe 'state', ->
  before ->
    @fr = new FormRenderer
      project_id: 1
      response_fields: []
      response:
        id: 'xxx'
        responses: {}

  describe 'hasChanges', ->
    it 'initially does not have changes', ->
      expect(@fr.state.get('hasChanges')).to.equal(false)

    describe 'after change event is fired', ->
      before ->
        @fr.response_fields.trigger('change')

      it 'has changes', ->
        expect(@fr.state.get('hasChanges')).to.equal(true)

describe 'local storage', ->
  it 'saves the draft ID'
  it 'loads the draft ID'
  it 'removes the draft ID after submitting'

describe '#loadFromServer', ->
  beforeEach ->
    @server = sinon.fakeServer.create()

  afterEach ->
    @server.restore()

  it 'loads just the project', ->
    @fr = new FormRenderer
      project_id: 1
      response:
        responses: { '1': 'hey' }

    @server.requests[0].respond 200, { "Content-Type": "application/json" }, JSON.stringify(
      project:
        id: 1
        response_fields: [
          id: 1
          label: 'Name'
          field_type: 'text'
        ]
    )

    expect($('input[type=text]').val()).to.equal('hey')

  it 'loads just the draft', ->
    @fr = new FormRenderer
      project_id: 1
      response_fields: [
        id: 1,
        label: 'Name',
        field_type: 'text'
      ]
      response:
        id: 'xxx'

    @server.requests[0].respond 200, { "Content-Type": "application/json" }, JSON.stringify(
      response:
        id: 'xxx'
        responses:
          '1': 'Adam'
    )

    expect($('input[type=text]').val()).to.equal('Adam')

  it 'loads both project and draft', ->
    @fr = new FormRenderer
      project_id: 1
      response:
        id: 'xxx'

    @server.requests[0].respond 200, { "Content-Type": "application/json" }, JSON.stringify(
      response:
        id: 'xxx'
        responses:
          '1': 'Adam'
      project:
        id: 1
        response_fields: [
          id: 1
          label: 'Name'
          field_type: 'text'
        ]
    )

    expect($('label').text()).to.have.string('Name')
    expect($('input[type=text]').val()).to.equal('Adam')

  it 'removes the draft ID on error', ->
    @fr = new FormRenderer
      project_id: 1
      response_fields: []
      response:
        id: 'xxx'

    storeSpy =
      remove: sinon.spy()

    window.store = storeSpy

    @server.requests[0].respond 400, { "Content-Type": "application/json" }, JSON.stringify({})

    expect(storeSpy.remove).to.have.been.called

describe 'options', ->
  describe 'enablePages', ->
    it 'is enabled by default'
    it 'disables pages'

  describe 'enableBottomStatusBar', ->
    it 'is enabled by default'
    it 'disables the bar'

  describe 'enableErrorAlertBar', ->
    it 'is enabled by default'
    it 'disables the bar'

  describe 'enableAutosave', ->
    it 'is enabled by default'
    it 'disables autosave'

  describe 'warnBeforeUnload', ->
    it 'is enabled by default'
    it 'disables BeforeUnload'

  describe 'validateImmediately', ->
    it 'is false by default'
    it 'validates immediately'

describe '#save', ->
  it 'sends the correct data to the server'
  it 'sets state on success'
  it 'sets state on error'
