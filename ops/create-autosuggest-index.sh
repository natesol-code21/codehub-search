#!/bin/bash

#
# This script creates the index, doc type, and mappings
#
# ASSUMPTIONS:
# -- Elastic Search is running
# -- Script is executed on the local box
#

SUCCESS=0
ERROR=1
HOST=54.165.103.241
PORT=9200
INDEX=projects_nate
TYPE=project

STATUS=$(curl -so /dev/null -w '%{response_code}' http://$HOST:$PORT/$INDEX)

if [ "$STATUS" -eq 200 ]; then
   echo "Index exists ... Updating Index Mappings and Settings"
   curl -X POST http://$HOST:$PORT/$INDEX/_close
   curl -X PUT http://$HOST:$PORT/$INDEX/_settings -d '{
   "analysis": {
       "analyzer": {
           "title_contributors_desc_readme_analyzer": {
             "type": "custom",
             "tokenizer": "standard",
             "char_filter": "my_char",
             "filter": ["lowercase","my_synonym_filter","my_stop", "ngram_title_contrib_desc_readme"]
           },
         "language_analyzer": {
           "type": "custom",
           "tokenizer": "standard",
           "char_filter": "my_char",
           "filter": ["lowercase","my_synonym_filter","edgy_lang"]
         }
       },
       "filter": {
            "ngram_title_contrib_desc_readme": {
                "type": "nGram",
                "min_gram": "2",
                "max_gram": "20",
                "token_chars": [
                  "letter",
                  "digit",
                  "punctuation",
                  "symbol"
               ]
            },
            "edgy_lang": {
                 "type": "edge_ngram",
                 "min_gram": "2",
                 "max_gram": "10"
             },
           "my_synonym_filter": {
               "type": "synonym",
  	       "synonyms": ["javascript=>js"]
             },
             "my_stop": {
              "type": "stop",
              "stopwords": "_english_"
             },
             "my_snow": {
              "type": "snowball",
              "language": "English"
             }
       },
       "char_filter": {
        "my_char": {
          "type": "mapping",
            "mappings": ["++ => plusplus", "# => sharp"]
           }
       }
   }
 }'
 curl -X POST http://$HOST:$PORT/$INDEX/_open
 curl -X PUT http://$HOST:$PORT/$INDEX/$TYPE/_mapping?ignore_conflicts=true -d '{
   "project" : {
        "properties" : {
          "commits" : {
            "type" : "long",
            "index": "no",
            "include_in_all": false
          },
          "contributors" : {
            "type" : "long",
            "index": "no",
            "include_in_all": false
          },
          "contributors_list" : {
            "properties" : {
              "avatar_url" : {
                "type" : "string",
                "index": "not_analyzed",
                "include_in_all": false
              },
              "profile_url" : {
                "type" : "string",
                "index": "not_analyzed",
                "include_in_all": false
              },
              "user_type" : {
                "type" : "string",
                "analyzer" : "title_contributors_desc_readme_analyzer"
              },
              "username" : {
                "type" : "string",
                "analyzer" : "title_contributors_desc_readme_analyzer"
              }
            }
          },
         "created_at" : {
            "type" : "date",
            "format" : "strict_date_optional_time||epoch_millis",
            "index": "not_analyzed",
            "include_in_all": false
          },
          "forks" : {
          "type":"object",
          "dynamic":"false",
          "properties": {
            "forkedRepos" : {
                "type":"object",
                "dynamic":"false",
                "properties" : {
                    "id" : {
                          "type" : "string",
                          "index": "no",
                          "include_in_all": false
                     },
                    "name" : {
                          "type" : "string",
                          "index": "no",
                          "include_in_all": false
                     },
                    "org_name" : {
                          "type" : "string",
                          "index": "no",
                          "include_in_all": false
                    }
                }
                }
          }
        },
          "full_name" : {
            "type" : "string",
            "index": "not_analyzed",
            "include_in_all": false
          },
          "stage_id" : {
            "type" : "string",
            "index": "not_analyzed",
            "include_in_all": false
          },
          "language" : {
            "type" : "string",
            "analyzer" : "language_analyzer"
          },
          "languages" : {
            "type":"object"
            "dynamic":"false"
          },
          "organization" : {
            "properties" : {
              "org_avatar_url" : {
                "type" : "string",
                "index": "no",
                "include_in_all": false
              },
              "org_type" : {
                "type" : "string",
                "index": "no",
                "include_in_all": false
              },
              "organization" : {
                "type" : "string",
                "index": "no",
                "include_in_all": false
              },
              "organization_url" : {
                "type" : "string",
                "index": "no",
                "include_in_all": false
              }
            }
          },
          "origin" : {
            "type" : "string",
            "index": "no",
            "include_in_all": false
          },
          "project_description" : {
            "type" : "string",
            "analyzer" : "title_contributors_desc_readme_analyzer"
          },
          "project_name" : {
            "type" : "string",
            "analyzer" : "title_contributors_desc_readme_analyzer"
          },
          "rank" : {
            "type" : "long",
            "index": "no",
            "include_in_all": false
          },
          "readMe" : {
            "properties" : {
              "content" : {
                "type" : "string",
                "analyzer" : "title_contributors_desc_readme_analyzer"
              },
              "url" : {
                "type" : "string",
                "index": "not_analyzed",
                "include_in_all": false

              }
            }
          },
          "releases" : {
            "type" : "long",
            "index": "no",
            "include_in_all": false
          },
          "repository" : {
            "type" : "string",
            "index": "no",
            "include_in_all": false
          },
          "repository_url" : {
            "type" : "string",
            "index": "no",
            "include_in_all": false
          },
          "stage_source" : {
            "type" : "string",
            "index": "no",
            "include_in_all": false
          },
          "stars" : {
            "type" : "long",
            "index": "no",
            "include_in_all": false
          },
          "suggest":{
            "type":"object",
            "dynamic":"false"
          }
          "updated_at" : {
            "type" : "date",
            "format" : "strict_date_optional_time||epoch_millis",
            "index": "not_analyzed",
            "include_in_all": false
          },
          "watchers" : {
            "type" : "long",
            "index": "no",
            "include_in_all": false
          }
        }
      }
 }'

elif [ "$STATUS" -eq 404 ]; then
   echo "Index doesn't exist...Creating new index with Mappings and Settings"
   # Create mapping for index
   curl -XPUT http://$HOST:$PORT/$INDEX/ -d '{
     "settings": {
         "analysis": {
             "analyzer": {
                 "title_contributors_desc_readme_analyzer": {
                   "type": "custom",
                   "tokenizer": "standard",
                   "char_filter": "my_char",
                   "filter": ["lowercase","my_synonym_filter","my_stop", "ngram_title_contrib_desc_readme"]
                 },
               "language_analyzer": {
                 "type": "custom",
                 "tokenizer": "standard",
                 "char_filter": "my_char",
                 "filter": ["lowercase","my_synonym_filter","edgy_lang"]
               }
             },
             "filter": {
                  "ngram_title_contrib_desc_readme": {
                      "type": "nGram",
                      "min_gram": "2",
                      "max_gram": "20",
                      "token_chars": [
                        "letter",
                        "digit",
                        "punctuation",
                        "symbol"
                     ]
                  },
                  "edgy_lang": {
                       "type": "edge_ngram",
                       "min_gram": "2",
                       "max_gram": "10"
                   },
                 "my_synonym_filter": {
                     "type": "synonym",
        	       "synonyms": ["javascript=>js"]
                   },
                   "my_stop": {
                    "type": "stop",
                    "stopwords": "_english_"
                   },
                   "my_snow": {
                    "type": "snowball",
                    "language": "English"
                   }
             },
             "char_filter": {
              "my_char": {
                "type": "mapping",
                  "mappings": ["++ => plusplus", "# => sharp"]
                 }
             }
         }
     },
   "mappings": {
       "project": {
            "properties" : {
              "commits" : {
                "type" : "long",
                "index": "no",
                "include_in_all": false
              },
              "contributors" : {
                "type" : "long",
                "index": "no",
                "include_in_all": false
              },
              "contributors_list" : {
                "properties" : {
                  "avatar_url" : {
                    "type" : "string",
                    "index": "not_analyzed",
                    "include_in_all": false
                  },
                  "profile_url" : {
                    "type" : "string",
                    "index": "not_analyzed",
                    "include_in_all": false
                  },
                  "user_type" : {
                    "type" : "string",
                    "analyzer" : "title_contributors_desc_readme_analyzer"
                  },
                  "username" : {
                    "type" : "string",
                    "analyzer" : "title_contributors_desc_readme_analyzer"
                  }
                }
              },
             "created_at" : {
                "type" : "date",
                "format" : "strict_date_optional_time||epoch_millis",
                "index": "not_analyzed",
                "include_in_all": false
              },
              "forks" : {
        	    "type":"object",
              "dynamic":"false",
        	    "properties": {
        		    "forkedRepos" : {
  	                "type":"object",
                    "dynamic":"false",
              			"properties" : {
              			    "id" : {
                				      "type" : "string",
                              "index": "no",
                              "include_in_all": false
                			   },
              			    "name" : {
              				        "type" : "string",
                              "index": "no",
                              "include_in_all": false
        			           },
              			    "org_name" : {
              				        "type" : "string",
                              "index": "no",
                              "include_in_all": false
              			    }
              			}
        	    	    }
        	    }
        	  },
              "full_name" : {
                "type" : "string",
                "index": "not_analyzed",
                "include_in_all": false
              },
              "stage_id" : {
                "type" : "string",
                "index": "not_analyzed",
                "include_in_all": false
              },
              "language" : {
                "type" : "string",
                "analyzer" : "language_analyzer"
              },
              "languages" : {
                "type" : "object",
                "dynamic":"false"
              },
              "organization" : {
                "properties" : {
                  "org_avatar_url" : {
                    "type" : "string",
                    "index": "no",
                    "include_in_all": false
                  },
                  "org_type" : {
                    "type" : "string",
                    "index": "no",
                    "include_in_all": false
                  },
                  "organization" : {
                    "type" : "string",
                    "index": "no",
                    "include_in_all": false
                  },
                  "organization_url" : {
                    "type" : "string",
                    "index": "no",
                    "include_in_all": false
                  }
                }
              },
              "origin" : {
                "type" : "string",
                "index": "no",
                "include_in_all": false
              },
              "project_description" : {
                "type" : "string",
                "analyzer" : "title_contributors_desc_readme_analyzer"
              },
              "project_name" : {
                "type" : "string",
                "analyzer" : "title_contributors_desc_readme_analyzer"
              },
              "rank" : {
                "type" : "long",
                "index": "no",
                "include_in_all": false
              },
              "readMe" : {
                "properties" : {
                  "content" : {
                    "type" : "string",
                    "analyzer" : "title_contributors_desc_readme_analyzer"
                  },
                  "url" : {
                    "type" : "string",
                    "index": "not_analyzed",
                    "include_in_all": false

                  }
                }
              },
              "releases" : {
                "type" : "long",
                "index": "no",
                "include_in_all": false
              },
              "repository" : {
                "type" : "string",
                "index": "no",
                "include_in_all": false
              },
              "repository_url" : {
                "type" : "string",
                "index": "no",
                "include_in_all": false
              },
              "stage_source" : {
                "type" : "string",
                "index": "no",
                "include_in_all": false
              },
              "stars" : {
                "type" : "long",
                "index": "no",
                "include_in_all": false
              },
              "suggest":{
                "type":"object",
                "dynamic":"false"
              },
              "updated_at" : {
                "type" : "date",
                "format" : "strict_date_optional_time||epoch_millis",
                "index": "not_analyzed",
                "include_in_all": false
              },
              "watchers" : {
                "type" : "long",
                "index": "no",
                "include_in_all": false
              }
            }
          }
   }
}'
else
   echo "please check whether the server is up...."
fi
