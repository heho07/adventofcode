SELECT
	*
INTO
	#tmp

FROM
	(
		VALUES
			(1713),
			(1281),
			(1185),
			(1501),
			(1462),
			(1752),
			(1363),
			(1799),
			(1071),
			(1446),
			(1685),
			(1706),
			(1726),
			(1567),
			(1867),
			(1376),
			(1445),
			(1971),
			(1429),
			(1749),
			(438),
			(1291),
			(1261),
			(1585),
			(1859),
			(1835),
			(1630),
			(1975),
			(1467),
			(1829),
			(1669),
			(1638),
			(1961),
			(1719),
			(1238),
			(1751),
			(1514),
			(1744),
			(1547),
			(1677),
			(1811),
			(1820),
			(1371),
			(740),
			(1925),
			(1803),
			(1753),
			(1208),
			(1772),
			(1642),
			(1140),
			(1838),
			(1444),
			(1321),
			(1556),
			(1635),
			(1687),
			(688),
			(1650),
			(1580),
			(1290),
			(1812),
			(1814),
			(1384),
			(1426),
			(1374),
			(1973),
			(1791),
			(1643),
			(1846),
			(1676),
			(1724),
			(1810),
			(1911),
			(1765),
			(945),
			(1357),
			(1919),
			(1994),
			(1697),
			(1632),
			(1449),
			(1539),
			(1725),
			(1963),
			(1879),
			(1731),
			(1904),
			(1392),
			(1823),
			(1420),
			(1504),
			(204),
			(1661),
			(1575),
			(1401),
			(1806),
			(1417),
			(1965),
			(1960),
			(1990),
			(1409),
			(1649),
			(1566),
			(1957),
			(514),
			(1464),
			(1352),
			(1841),
			(1601),
			(1473),
			(1309),
			(1421),
			(1190),
			(1582),
			(1825),
			(655),
			(1666),
			(1878),
			(1891),
			(1579),
			(1176),
			(1557),
			(1910),
			(1747),
			(1388),
			(1493),
			(1372),
			(1522),
			(1515),
			(1745),
			(1494),
			(1763),
			(1147),
			(1364),
			(1469),
			(1165),
			(1901),
			(1368),
			(1234),
			(1308),
			(1416),
			(1678),
			(1541),
			(1509),
			(1427),
			(1223),
			(1496),
			(1600),
			(1383),
			(1295),
			(1415),
			(1890),
			(1694),
			(1793),
			(1529),
			(1984),
			(1576),
			(1244),
			(1348),
			(1085),
			(1770),
			(1358),
			(1611),
			(1159),
			(1964),
			(1647),
			(818),
			(1246),
			(1458),
			(1936),
			(1370),
			(1659),
			(1923),
			(1619),
			(1604),
			(1354),
			(1118),
			(1657),
			(1945),
			(1898),
			(1948),
			(798),
			(769),
			(1689),
			(1821),
			(1979),
			(1460),
			(1832),
			(1596),
			(1679),
			(1818),
			(1815),
			(1977),
			(1634),
			(1828),
			(1386),
			(1284),
			(1569),
			(1970)
	) AS V(value)


-- task 1
SELECT
	T.value AS [V1],
	T2.value AS [V2],
	T.value * T2.value AS [Product]
FROM
	#tmp T
	JOIN #tmp T2 ON
		T2.value <> T.value
WHERE
	T.value + T2.value = 2020

-- task 2
SELECT
	T.value AS [V1],
	T2.value AS [V2],
	T3.value AS [V3],
	T.value * T2.value * T3.value AS [Product]
FROM
	#tmp T
	JOIN #tmp T2 ON
		T2.value <> T.value
	JOIN #tmp T3 ON
		T3.value <> T.value AND
		T3.value <> T2.value
WHERE
	T.value + T2.value + T3.value = 2020