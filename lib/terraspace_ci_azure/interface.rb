require "uri"

module TerraspaceCiAzure
  class Interface
    # Interface method. Returns Hash of properties.
    def vars
      {
        build_system: "azure",
        host: host,
        full_repo: full_repo,
        branch_name: branch_name,
        # urls
        pr_url: pr_url,
        build_url: build_url,
        branch_url: branch_url,
        commit_url: commit_url,
        # additional properties
        build_type: build_type,
        pr_number: pr_number,
        sha: sha,
        # additional properties
        # commit_message: ENV['REPLACE_ME'],
        build_id: build_id,
        build_number: ENV['BUILD_BUILDNUMBER'], # IE: BUILD_BUILDNUMBER=20220715.12
      }
    end

    def branch_name
      if pr_number
        message = ENV['BUILD_SOURCEVERSIONMESSAGE']
        md = message.match(/Merge pull request \d+ from (.*) into (.*)/)
        if md
          # IE: BUILD_SOURCEVERSIONMESSAGE=Merge pull request 2 from feature into main
          # Its a bit weird but with azure repos with check policy trigger
          md[1]
        else # GitHub and Bitbucket PR has actual branch though
          # IE: SYSTEM_PULLREQUEST_SOURCEBRANCH=feature
          message
        end
      else # push
        ENV['BUILD_SOURCEBRANCHNAME']
      end
    end

    def sha
      ENV['BUILD_SOURCEVERSION']
    end

    # IE: BUILD_REPOSITORY_URI=https://tongueroo@dev.azure.com/tongueroo/infra-project/_git/infra-ci
    def host
      uri = URI(ENV['BUILD_REPOSITORY_URI'])
      "#{uri.scheme}://#{uri.host}"
    end

    # removes the user@ part
    # IE: BUILD_REPOSITORY_URI=https://tongueroo@dev.azure.com/tongueroo/infra-project/_git/infra-ci
    def base_project_url
      uri = URI(ENV['BUILD_REPOSITORY_URI'])
      base_path = uri.path.split('/')[0..2].join('/')
      "#{uri.scheme}://#{uri.host}#{base_path}"
    end

    def base_repo_url
      uri = URI(ENV['BUILD_REPOSITORY_URI'])
      "#{uri.scheme}://#{uri.host}#{uri.path}"
    end

    # IE: BUILD_REPOSITORY_URI=https://tongueroo@dev.azure.com/tongueroo/infra-project/_git/infra-ci
    def full_repo
      uri = URI(ENV['BUILD_REPOSITORY_URI'])
      org = uri.path.split('/')[1] # since there's a leading /
      repo = ENV['BUILD_REPOSITORY_NAME'] # tongueroo
      "#{org}/#{repo}"
    end

    def build_type
      ENV['SYSTEM_PULLREQUEST_PULLREQUESTID'] ? 'pull_request' : 'push'
    end

    # IE: SYSTEM_PULLREQUEST_PULLREQUESTID=2
    def pr_number
      ENV['SYSTEM_PULLREQUEST_PULLREQUESTID']
    end

    def build_id
      ENV['BUILD_BUILDID']
    end

    # https://dev.azure.com/tongueroo/infra-project/_git/infra-ci/pullrequest/2
    # IE: BUILD_REPOSITORY_URI=https://tongueroo@dev.azure.com/tongueroo/infra-project/_git/infra-ci
    def pr_url
      return unless pr_number
      uri = URI(ENV['BUILD_REPOSITORY_URI'])
      "#{base_repo_url}/pullrequest/#{pr_number}"
    end

    # IE: BUILD_BUILDID=74
    # https://dev.azure.com/tongueroo/infra-project/_build/results?buildId=152&view=results
    def build_url
      return unless build_id
      "#{base_project_url}/_build/results?buildId=#{build_id}&view=results"
    end

    # IE: https://dev.azure.com/tongueroo/infra-project/_git/infra-ci/commit/2eac582a6c0582c426f5304619aafd1db4f12434
    def commit_url
      "#{base_repo_url}/commit/#{sha}"
    end

    # IE: https://dev.azure.com/tongueroo/infra-project/_git/infra-ci?version=GBfeature
    def branch_url
      "#{base_repo_url}?version=GB#{branch_name}"
    end
  end
end
