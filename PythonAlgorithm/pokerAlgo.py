import heapq
import collections
from functions_framework import http
from flask import jsonify

def round_to_2_sig_figs(num):
    if num == 0:
        return 0
    else:
        return float(f"{num:.2g}")

def checkAmount(standings):
    totalStart = 0
    totalEnd = 0
    for stats in standings:
        name, start, end = stats
        totalStart += float(start)
        totalEnd += float(end)

    diff = round_to_2_sig_figs(totalStart - totalEnd)

    if totalEnd == totalStart:
        return 1
    elif totalStart > totalEnd:
        return f"Error, we are missing {diff}$. Total is at {round_to_2_sig_figs(totalEnd)}$ but should be at {round_to_2_sig_figs(totalStart)}$"
    else:
        return f"Error, we have an extra {diff}$. Total is at {round_to_2_sig_figs(totalEnd)}$ but should be at {round_to_2_sig_figs(totalStart)}$"


def pokerAlgo(standings):
    resCheck = checkAmount(standings)
    if  resCheck != 1:
        return jsonify(resCheck)

    queueWinners = []
    queueLosers = []

    for stats in standings:
        name, start, end = stats
        difference = float(end) - float(start)

        if difference >= 0:
            heapq.heappush(queueWinners, (-abs(difference), name))
        else:
            heapq.heappush(queueLosers, (-abs(difference), name))

    results = collections.defaultdict(list)

    while queueLosers:

        topWinnerName = queueWinners[0][1]
        topWinnerAmount = abs(queueWinners[0][0])
        topLoserName = queueLosers[0][1]
        topLoserAmount = abs(queueLosers[0][0])

        heapq.heappop(queueLosers)
        heapq.heappop(queueWinners)

        difference = abs(topWinnerAmount - topLoserAmount)

        if topWinnerAmount == topLoserAmount:
            results[topLoserName].append([topWinnerName, str(topLoserAmount)])
        elif topWinnerAmount > topLoserAmount:
            heapq.heappush(queueWinners, (-difference, topWinnerName))
            results[topLoserName].append([topWinnerName, str(topLoserAmount)])
        else:
            heapq.heappush(queueLosers, (-difference, topLoserName))
            results[topLoserName].append([topWinnerName, str(topWinnerAmount)])

    arrayRes = [[k, v] for k, v in results.items()]

    return jsonify(arrayRes)


@http
def handle_request(request):
    request_json = request.get_json(silent=True)

    if not request_json or 'standings' not in request_json:
        return jsonify(error="Invalid input"), 400

    standings = request_json['standings']

    return pokerAlgo(standings)
