shared_examples "index page" do
  it { should have_title page_title(title) }
  it { should have_selector 'h1', text: title }
end

shared_examples "with admin content" do
  it "shows admin stuff only for admin" do
    visit path
    expect(page).not_to have_contents admin_only
    expect(page).not_to have_links admin_actions
    sign_in
    visit path
    expect(page).to have_contents admin_only
    expect(page).to have_links admin_actions
  end
end
