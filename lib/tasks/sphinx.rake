namespace :sphinx do
  desc "generate xml that is sphinx-friendly"
  task :genxml => :environment do
    # Generates the xml files
    Account.xml_for_sphinx_pipe
    Contact.xml_for_sphinx_pipe
    Lead.xml_for_sphinx_pipe
  end

  desc "start up the sphinx daemon"
  task :start => :environment do
    cmd = %( searchd --config #{Rails.root}/config/sphinx.conf )
    system! cmd
  end

  desc "stop the sphinx daemon"
  task :stop => :environment do
    system! %( searchd --config #{Rails.root}/config/sphinx.conf --stop )
  end

  desc "run the sphinx indexer"
  task :index => :environment do
    Rake::Task['sphinx:genxml'].invoke
    cmd = %( indexer --config #{Rails.root}/config/sphinx.conf --rotate --all --quiet )
    cmd << ' --rotate' if ENV['rotate'] && ENV['rotate'].downcase == 'true'
    system! cmd
  end
end

# a fail-fast, hopefully helpful version of system
def system!(cmd)
  unless system(cmd)
    raise <<-SYSTEM_CALL_FAILED
The following command failed:
  #{cmd}
SYSTEM_CALL_FAILED
  end
end
