# me-mail

Quickly send a letter (to yourself).

## Usage

On the command line:

```
$ ruby me-mail.rb --live --file ~/path/to/my_letter.txt
```

### Installation

This is not a gem. Just clone the repo, `cd` into it, and run `bundle`.

You'll need some API keys from Lob.com. Add the following environment variables to your `~/.bash_profile` or similar:

- `export LOB_TEST_API_KEY='...'`
- `export LOB_LIVE_API_KEY='...'`

### Configuration

Omitting `--live` means the Lob.com test API key is used.

`--file` takes a path a `.txt` file.

Copy the `address.yml.example` file:

```
$ cp address.yml.example address.yml
```

Then fill in your own values. By default, the `from` field will match the `to` field. But you can override this.
