require 'rails_helper'
require 'spec_helper'

RSpec.describe ProjectsController do
  # Who can create? Client
  describe "POST create" do
    let(:client_user) do
      user = create :user, :client
      client = create :client, user: user
      organization = create :organization, :verified
      create :organization_detail, :owner, client: client, organization: organization
      user
    end
    let(:creation_params) {
      {
        project: {
          title: Faker::Book.title,
          description: Faker::Quote.famous_last_words,
          budget: rand(0.00..1000.00),
          start_time: DateTime.current,
          end_time: 1.month.from_now,
          required_number_of_influencers: rand(1..5),
          status: 'draft',
          payment_type: 'Cash',
          target_audience: 'Gen-Z',
          views: rand(100..500)
        }
      }
    }

    context "when user is not signed_in" do
      it "will not be created" do
        post 'create', params: creation_params
        expect(Project.count).to eq(0)
      end
    end

    context "when user is signed_in" do
      before :each do
        sign_in(client_user, scope: :user)
      end
      context "when user is signed in as creator" do
        it "will not create the project" do
          session_params = {user_role: User::USER_ROLES[:influencer]}
          expect(Project.count).to eq(0)
          expect do
            post 'create', params: creation_params, session: session_params
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end

      context "when user is client" do
        let(:session_params) {{user_role: User::USER_ROLES[:client]}}

        it "will create project" do
          post 'create', params: creation_params, session: session_params
          expect(Project.count).to eq(1)
          # expect(Project.find_by(creation_params[:project])).to be_present
        end

        context "when project_platforms is present" do
          let(:platform) { create(:platform) }
          it "will create project_platforms" do
            project_platform_attributes = {
              project_platforms_attributes: [{ platform_id: platform.id }]
            }
            creation_params[:project].merge!(project_platform_attributes)
            post 'create', params: creation_params, session: session_params
            expect(ProjectPlatform.count).to eq(1)
          end
        end

        context "when project_platforms is absent" do
          it "will not create project_platforms" do
            post 'create', params: creation_params, session: session_params
            expect(ProjectPlatform.count).not_to eq(1)
          end
        end

        context "when project_categories is present" do
          let(:category) { create(:category) }
          it "will create project_categories" do
            project_categories_attributes = {
              project_categories_attributes: [{ category_id: category.id }]
            }
            creation_params[:project].merge!(project_categories_attributes)
            post 'create', params: creation_params, session: session_params
            expect(ProjectCategory.count).to eq(1)
          end
        end

        context "when project_categories is absent" do
          it "will not create project_categories" do
            post 'create', params: creation_params, session: session_params
            expect(ProjectCategory.count).not_to eq(1)
          end
        end

        context "when project_milestones is present" do
          it "will create project_milestones" do
            project_milestones_attributes = {
              project_milestones_attributes: [
                {
                  title: Faker::Book.title,
                  description: Faker::Quote.famous_last_words,
                  reach: rand(1..10000),
                  conversion: rand(1..1000),
                  budget: rand(1.00..100.00)
                }
              ]
            }
            creation_params[:project].merge!(project_milestones_attributes)
            post 'create', params: creation_params, session: session_params
            expect(ProjectMilestone.count).to eq(1)
          end
        end

        context "when project_milestones is absent" do
          it "will not create project_milestones" do
            post 'create', params: creation_params, session: session_params
            expect(ProjectMilestone.count).not_to eq(1)
          end
        end

        context "when example_works is present" do
          it "will create example_works" do
            example_works_attributes = {
              example_works_attributes: [
                {
                  title: Faker::Book.title,
                  description: Faker::Quote.famous_last_words
                }
              ]
            }
            creation_params[:project].merge!(example_works_attributes)
            post 'create', params: creation_params, session: session_params
            expect(ExampleWork.count).to eq(1)
          end
        end

        context "when example_works is absent" do
          it "will not create example_works" do
            post 'create', params: creation_params, session: session_params
            expect(ExampleWork.count).not_to eq(1)
          end
        end
      end

      context "when client is absent" do
        it "will not create project" do
          expect do
            post 'create', params: creation_params
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
  end

  # Who can update?
  # - Client who is the owner
  # - Reviewer can only update reviewed property
  describe "PUT/PATCH update" do
    let(:client_user) do
      user = create :user, :client
      client = create :client, user: user
      create :organization_detail, :owner, client: client
      user
    end
    let(:project) { create(:project, organization: client_user.client.organization) }
    let(:updation_params) {
      {
        id: project.id,
        project: {
          title: Faker::Book.title,
          description: Faker::Quote.famous_last_words,
          budget: rand(0.00..1000.00),
          start_time: DateTime.current,
          end_time: 1.month.from_now,
          required_number_of_influencers: 6,
          status: 'ready_for_review',
          payment_type: 'exposure',
          target_audience: 'Boomer',
          views: rand(100..500)
        }
      }
    }

    context "when user is not signed_in" do
      it "will not be updated" do
        put 'update', params: updation_params
        update_keys = [
          :title, :description, :budget, :status, :required_number_of_influencers, :target_audience
        ].map { |k, _| k.to_sym}
        update_keys.each do |key|
          expect(project.reload.send(key)).not_to eq(updation_params[:project][key])
        end
      end
    end

    context "when user is signed_in" do
      context "when user is owner" do
        before :each do
          sign_in(project.organization.owner.user, scope: :user)
        end
        context "when user is signed in as client" do
          let(:platform) { create(:platform) }
          let(:category) { create(:category) }

          let(:project_milestones_columns) {
            {
              project_milestones_attributes: [
                {
                  title: Faker::Book.title,
                  description: Faker::Quote.famous_last_words,
                  reach: 20000,
                  conversion: 2000,
                  budget: 200.00
                }
              ]
            }
          }
          let(:project_platforms_columns) {
            {
              project_platforms_attributes: [
                {
                  platform_id: platform.id
                }
              ]
            }
          }
          let(:project_categories_columns) {
            {
              project_categories_attributes: [
                {
                  category_id: category.id
                }
              ]
            }
          }
          let(:example_works_columns) {
            {
              example_works_attributes: [
                {
                  title: Faker::Book.title,
                  description: Faker::Quote.famous_last_words
                }
              ]
            }
          }

          it "will update the project" do
            session_params = {user_role: User::USER_ROLES[:client]}
            put 'update', params: updation_params, session: session_params
            update_keys = [
              :title, :description, :budget, :required_number_of_influencers, :target_audience
            ].map { |k, _| k.to_sym}
            update_keys.each do |key|
              expect(project.reload.send(key)).to eq(updation_params[:project][key])
            end
          end

          context "when project_platforms already exist" do
            context "when project_platforms is passed" do
              it "will add another project_platform" do
                project.project_platforms << create(:project_platform)
                session_params = {user_role: User::USER_ROLES[:client]}
                updation_params[:project].merge!(project_platforms_columns)
                expect do
                  put 'update', params: updation_params, session: session_params
                end.to change{ project.reload.platforms.count }.by(1)
                expect(project.reload.platforms.count).to eq(2)
              end
            end
            context "when project_platforms is passed with _delete key" do
              it "will delete the given project_platform" do
                project.project_platforms << create(:project_platform)
                session_params = {user_role: User::USER_ROLES[:client]}
                project_platforms_columns[:project_platforms_attributes].first.merge!(
                  id: project.project_platforms.first.id,
                  platform_id: project.platforms.first.id,
                  _destroy: true
                )
                updation_params[:project].merge!(project_platforms_columns)
                expect do
                  put 'update', params: updation_params, session: session_params
                end.to change{ project.reload.platforms.count }.by(-1)
                expect(project.reload.platforms.count).to eq(0)
              end
            end
            it "will update the project_platforms record" do
              project.project_platforms << create(:project_platform)
              session_params = {user_role: User::USER_ROLES[:client]}
              project_platforms_columns[:project_platforms_attributes].first.merge!(
                id: project.project_platforms.first.id,
                platform_id: project.platforms.first.id
              )
              updation_params[:project].merge!(project_platforms_columns)
              expect do
                put 'update', params: updation_params, session: session_params
              end.to change{ project.reload.platforms.count }.by(0)
              expect(project.reload.platforms.count).to eq(1)
            end
          end
          context "when project_platforms does not exist" do
            context "when project_platforms is passed" do
              it "will create a platform project" do
                session_params = {user_role: User::USER_ROLES[:client]}
                updation_params[:project].merge!(project_platforms_columns)
                expect do
                  put 'update', params: updation_params, session: session_params
                end.to change{ project.reload.platforms.count }.by(1)
                expect(project.reload.platforms.count).to eq(1)
              end
            end
          end

          context "when project_categories already exist" do
            context "when project_categories is passed" do
              it "will add another project_categories" do
                project.project_categories << create(:project_category)
                session_params = {user_role: User::USER_ROLES[:client]}
                updation_params[:project].merge!(project_categories_columns)
                expect do
                  put 'update', params: updation_params, session: session_params
                end.to change{ project.reload.categories.count }.by(1)
                expect(project.reload.categories.count).to eq(2)
              end
            end
            context "when project_categories is passed with _delete key" do
              it "will delete the given project_categories" do
                project.project_categories << create(:project_category)
                session_params = {user_role: User::USER_ROLES[:client]}
                project_categories_columns[:project_categories_attributes].first.merge!(
                  id: project.project_categories.first.id,
                  category_id: project.categories.first.id,
                  _destroy: true
                )
                updation_params[:project].merge!(project_categories_columns)
                expect do
                  put 'update', params: updation_params, session: session_params
                end.to change{ project.reload.categories.count }.by(-1)
                expect(project.reload.categories.count).to eq(0)
              end
            end
            it "will update the record" do
              project.project_categories << create(:project_category)
              session_params = {user_role: User::USER_ROLES[:client]}
              project_categories_columns[:project_categories_attributes].first.merge!(
                id: project.project_categories.first.id,
                category_id: project.categories.first.id
              )
              updation_params[:project].merge!(project_categories_columns)
              expect do
                put 'update', params: updation_params, session: session_params
              end.to change{ project.reload.categories.count }.by(0)
              expect(project.reload.categories.count).to eq(1)
            end
          end
          context "when project_categories does not exist" do
            context "when project_categories is passed" do
              it "will add project_categories" do
                session_params = {user_role: User::USER_ROLES[:client]}
                updation_params[:project].merge!(project_categories_columns)
                expect do
                  put 'update', params: updation_params, session: session_params
                end.to change{ project.reload.categories.count }.by(1)
                expect(project.reload.categories.count).to eq(1)
              end
            end
          end

          context "when project_milestones already exist" do
            context "when project_milestones is passed" do
              it "will add another project_milestones" do
                project.project_milestones << create(:project_milestone)
                session_params = {user_role: User::USER_ROLES[:client]}
                updation_params[:project].merge!(project_milestones_columns)
                expect do
                  put 'update', params: updation_params, session: session_params
                end.to change{ project.reload.project_milestones.count }.by(1)
                expect(project.reload.project_milestones.count).to eq(2)
              end
            end
            context "when project_milestones is passed with _delete key" do
              it "will delete the given project_milestones" do
                project.project_milestones << create(:project_milestone)
                session_params = {user_role: User::USER_ROLES[:client]}
                project_milestones_columns[:project_milestones_attributes].first.merge!(
                  id: project.project_milestones.first.id,
                  _destroy: true
                )
                updation_params[:project].merge!(project_milestones_columns)
                expect do
                  put 'update', params: updation_params, session: session_params
                end.to change{ project.reload.project_milestones.count }.by(-1)
                expect(project.reload.project_milestones.count).to eq(0)
              end
            end
            it "will update the record" do
              project.project_milestones << create(:project_milestone)
              session_params = {user_role: User::USER_ROLES[:client]}
              project_milestones_columns[:project_milestones_attributes].first.merge!(
                id: project.project_milestones.first.id,
                description: "Hello"
              )
              updation_params[:project].merge!(project_milestones_columns)
              expect do
                put 'update', params: updation_params, session: session_params
              end.to change{ project.reload.project_milestones.count }.by(0)
              expect(project.reload.project_milestones.count).to eq(1)
            end
          end
          context "when project_milestones does not exist" do
            context "when project_milestones is passed" do
              it "will add project_milestones" do
                session_params = {user_role: User::USER_ROLES[:client]}
                updation_params[:project].merge!(project_milestones_columns)
                expect do
                  put 'update', params: updation_params, session: session_params
                end.to change{ project.reload.project_milestones.count }.by(1)
                expect(project.reload.project_milestones.count).to eq(1)
              end
            end
          end

          context "when example_works already exist" do
            context "when example_works is passed" do
              it "will add another example_works" do
                project.example_works << create(:example_work)
                session_params = {user_role: User::USER_ROLES[:client]}
                updation_params[:project].merge!(example_works_columns)
                expect do
                  put 'update', params: updation_params, session: session_params
                end.to change{ project.reload.example_works.count }.by(1)
                expect(project.reload.example_works.count).to eq(2)
              end
            end
            context "when example_works is passed with _delete key" do
              it "will delete the given example_works" do
                project.example_works << create(:example_work)
                session_params = {user_role: User::USER_ROLES[:client]}
                example_works_columns[:example_works_attributes].first.merge!(
                  id: project.example_works.first.id,
                  _destroy: true
                )
                updation_params[:project].merge!(example_works_columns)
                expect do
                  put 'update', params: updation_params, session: session_params
                end.to change{ project.reload.example_works.count }.by(-1)
                expect(project.reload.example_works.count).to eq(0)
              end
            end
            it "will update the record" do
              project.example_works << create(:example_work)
              session_params = {user_role: User::USER_ROLES[:client]}
              example_works_columns[:example_works_attributes].first.merge!(
                id: project.example_works.first.id,
              )
              updation_params[:project].merge!(example_works_columns)
              expect do
                put 'update', params: updation_params, session: session_params
              end.to change{ project.reload.example_works.count }.by(0)
              expect(project.reload.example_works.count).to eq(1)
            end
          end
          context "when example_works does not exist" do
            context "when example_works is passed" do
              it "will add example_works" do
                session_params = {user_role: User::USER_ROLES[:client]}
                updation_params[:project].merge!(example_works_columns)
                expect do
                  put 'update', params: updation_params, session: session_params
                end.to change{ project.reload.example_works.count }.by(1)
                expect(project.reload.example_works.count).to eq(1)
              end
            end
          end
        end
        context "when user is signed in as creator" do
          it "will not update the project" do
            session_params = {user_role: User::USER_ROLES[:influencer]}
            expect do
              put 'update', params: updation_params, session: session_params
            end.to raise_error(Pundit::NotAuthorizedError)
          end
        end
      end

      context "when user is not the owner" do
        let(:user) { create(:user, :client)}
        before :each do
          sign_in(user, scope: :user)
        end
        it "will not update the project" do
          session_params = {user_role: User::USER_ROLES[:client]}
          expect do
            put 'update', params: updation_params, session: session_params
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end

      xit "when user is of type reviewer" do
        post 'create', params: updation_params
        expect(Project.count).to eq(1)
        expect(Project.find_by(updation_params[:project])).to be_present
      end
    end
  end
end
