extern "C"
{
	int getmax(int *array, int size) 
	{
		int max = array[0];
		for (int i = 1; i < size; i++)
		{
			if (array[i] > max)
			{
				max = array[i];
			}
		}
		return max;
	}

	int getmin(int *array, int size) 
	{
		int min = array[0];
		for (int i = 1; i < size; i++)
		{
			if (array[i] < min)
			{
				min = array[i];
			}
		}
		return min;
	}
}