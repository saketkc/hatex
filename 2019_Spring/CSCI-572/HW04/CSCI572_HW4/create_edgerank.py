import pandas as pd
from bs4 import BeautifulSoup
import glob
import ntpath
import networkx as nx


def path_leaf(path):
    head, tail = ntpath.split(path)
    return tail or ntpath.basename(head)


def get_outgoing_links(html_file):
    """Get list of outgoing links for the input html file.
    
    Parameters
    ----------
    html_file: str
               Path to html file
    
    Returns
    -------
    list_of_urls: list
                  List of outgoing urls
    
    """

    soup = BeautifulSoup(open(html_file).read().encode("utf-8"))
    links = []
    for link in soup.findAll(
        "a", href=True
    ):  # attrs=['href']: re.compile("^https://")}):
        # Skip internal linkes
        try:
            href = link.get("href")
        except IndexError:
            continue

        if href == "#":
            continue
        try:
            text = link.contents[0]
        except IndexError:
            # text = ''
            pass
        links.append(link.get("href"))
    return links


def get_filenames_for_URLs(mapping_file_df, list_of_links):
    """Get list of html filenames for a list of links
    
    Parameters
    ----------
    mapping_file_df: pd.DataFrame
                     Dataframe with mapping.csv loaded
    list_of_links: list
                   List of URLs
                   
    Returns
    -------
    list_of_filenames: list
                       List of filenames
    """

    return mapping_file_df[mapping_file_df.URL.isin(list_of_links)].filename.tolist()


def main():
    crawl_data_dir = (
        "/media/rna/yahoo_crawl_data/Yahoo-20190406T235503Z-001/Yahoo/yahoo/"
    )
    csv_file = "/media/rna/yahoo_crawl_data/Yahoo-20190406T235503Z-001/Yahoo/URLtoHTML_yahoo_news.csv"
    mapping_file_df = (
        pd.read_csv(csv_file).sort_values(by=["filename", "URL"]).reset_index(drop=True)
    )
    list_of_html_files = glob.glob("{}/*.html".format(crawl_data_dir))
    with open("edgeList.txt", "w") as fh:
        for filepath in list_of_html_files:
            filename = path_leaf(filepath)
            links = get_outgoing_links(filepath)
            filenames_for_url = get_filenames_for_URLs(mapping_file_df, links)
            # connection_matrix.loc[filename, filenames_for_url]+=1
            # connection_matrix.loc[filename, filenames_for_url] =1
            # with open()
            fh.write("{} {}\n".format(filename, " ".join(filenames_for_url)))

    G = nx.read_adjlist("edgeList.txt", create_using=nx.DiGraph())
    pagerank = nx.pagerank(
        G,
        alpha=0.85,
        personalization=None,
        max_iter=100,
        tol=1e-06,
        nstart=None,
        weight="weight",
        dangling=None,
    )
    with open("external_PageRankFile.txt", "w") as fh:
        for key, value in pagerank.items():
            fh.write("{}/{}={}\n".format(crawl_data_dir, key, value))


if __name__ == "__main__":
    main()
