import os
from flask import Flask

tree = "Sequoia"

api = Flask(__name__)
port=int(os.environ.get("PORT", 5000))

@api.route('/tree', methods=['GET'])
def get_tree():
  return {"myFavouriteTree": tree}

if __name__ == '__main__':
    api.run(host="0.0.0.0", port=port)
