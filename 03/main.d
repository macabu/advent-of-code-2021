import std.exception;
import std.stdio;
import std.conv;
import std.range;

void part_one()
{
    int[12] onesInPosition;

    auto totalLines = 0;

    try
    {
        auto powersFile = File("input.txt", "r");

        foreach (line; powersFile.byLine)
        {
            totalLines++;

            auto decimalLine = to!int(line, 2);

            onesInPosition[0] += (decimalLine >> 0x0) & 0x1;
            onesInPosition[1] += (decimalLine >> 0x1) & 0x1;
            onesInPosition[2] += (decimalLine >> 0x2) & 0x1;
            onesInPosition[3] += (decimalLine >> 0x3) & 0x1;
            onesInPosition[4] += (decimalLine >> 0x4) & 0x1;
            onesInPosition[5] += (decimalLine >> 0x5) & 0x1;
            onesInPosition[6] += (decimalLine >> 0x6) & 0x1;
            onesInPosition[7] += (decimalLine >> 0x7) & 0x1;
            onesInPosition[8] += (decimalLine >> 0x8) & 0x1;
            onesInPosition[9] += (decimalLine >> 0x9) & 0x1;
            onesInPosition[10] += (decimalLine >> 0xA) & 0x1;
            onesInPosition[11] += (decimalLine >> 0xB) & 0x1;
        }

        powersFile.close();
    }
    catch (ErrnoException ex)
    {
        writeln(ex);
        return;
    }

    auto gammaRate = 0;
    auto epsilonRate = 0;

    foreach (i, e; onesInPosition)
    {
        if (e > totalLines / 2)
        {
            gammaRate |= 1 << i;
        }
        else
        {
            epsilonRate |= 1 << i;
        }
    }

    writeln("Gamma Rate = ", gammaRate);
    writeln("Epsilon Rate = ", epsilonRate);
    writeln("Power Consumption = ", gammaRate * epsilonRate);
}

void part_two()
{
    int commonality(int[] arr, bool mostCommon)
    {
        int[12] onesInPosition;
        auto mostAtEachPosition = 0;
        auto leastAtEachPosition = 0;

        foreach (decimalLine; arr)
        {
            onesInPosition[0] += (decimalLine >> 0x0) & 0x1;
            onesInPosition[1] += (decimalLine >> 0x1) & 0x1;
            onesInPosition[2] += (decimalLine >> 0x2) & 0x1;
            onesInPosition[3] += (decimalLine >> 0x3) & 0x1;
            onesInPosition[4] += (decimalLine >> 0x4) & 0x1;
            onesInPosition[5] += (decimalLine >> 0x5) & 0x1;
            onesInPosition[6] += (decimalLine >> 0x6) & 0x1;
            onesInPosition[7] += (decimalLine >> 0x7) & 0x1;
            onesInPosition[8] += (decimalLine >> 0x8) & 0x1;
            onesInPosition[9] += (decimalLine >> 0x9) & 0x1;
            onesInPosition[10] += (decimalLine >> 0xA) & 0x1;
            onesInPosition[11] += (decimalLine >> 0xB) & 0x1;
        }

        foreach (i, e; onesInPosition)
        {
            if (e >= arr.length / 2)
            {
                mostAtEachPosition |= 1 << i;
            }
            else
            {
                leastAtEachPosition |= 1 << i;
            }
        }

        return mostCommon
            ? mostAtEachPosition : leastAtEachPosition;
    }

    int[] getCommonSequence(int[] arr, int i, bool most)
    {
        if (arr.length == 1 || i == 12)
        {
            return arr;
        }

        auto mostCommon = commonality(arr, most);
        auto mostCommonStr = to!string(mostCommon, 2);
        auto ms = mostCommonStr.split("").padLeft("0", 12);

        int[] ret;
        foreach (e; arr)
        {
            auto estr = to!string(e, 2);
            auto esplit = estr.split("").padLeft("0", 12);
            if (esplit[i] == ms[i])
            {
                ret ~= e;
            }
        }

        return getCommonSequence(ret, i + 1, most);
    }

    int[] numbers;

    try
    {
        auto powersFile = File("input.txt", "r");

        foreach (line; powersFile.byLine)
        {
            numbers ~= to!int(line, 2);
        }

        powersFile.close();
    }
    catch (ErrnoException ex)
    {
        writeln(ex);
        return;
    }

    auto most = getCommonSequence(numbers, 0, true)[0];
    auto least = getCommonSequence(numbers, 0, false)[0];

    writefln("Most = %b - %d", most, most);
    writefln("Least = %b - %d", least, least);
    writefln("Power = %d", most * least);
}

void main()
{
    writeln("Part 1 ===");
    part_one();
    writeln("Part 2 ===");
    part_two();
}
