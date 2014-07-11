shared_examples "index page" do
  it { should have_title page_title(title) }
  it { should have_selector 'h1', text: title }
end
