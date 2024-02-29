namespace :git_repair do
  desc <<-END_DESC
Remove the given full changeset id from a git repository records list of heads.

Available options:
  * changeset => full hash of head to remove

Example:
  rake git_repair:remove_head changeset=2bfeda78e28e58e6fadf23175508f2e4ce8bb9a3 RAILS_ENV="production"
END_DESC

  task :remove_head => :environment do
    changeset = ENV['changeset']
    condition = "%" + Repository.sanitize_sql_like(changeset) + "%"
    Repository.where("extra_info like ?", condition).find_each do |repo|
      removed = repo.extra_info["heads"].delete(changeset)
      if removed
        repo.save
        puts "Removed changeset: " + removed + " from repo id=" + repo.id
      end
    end
  end
end
