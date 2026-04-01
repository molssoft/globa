<?
class Pagination
{
	private $totalItems;
	private $itemsPerPage;
	private $currPage;

	public function __construct($totalItems, $itemsPerPage, $currPage)
	{
		$this->totalItems = $totalItems;
		$this->itemsPerPage = $itemsPerPage;
		$this->currPage = $currPage;
	}

	public function getLinksHtml($baseUrl, $pageVar)
	{
		$html = "";

		if ($this->hasPrev()) {
			$html .= '<a href="'.$baseUrl.'?'.$pageVar.'='.($this->currPage-1).'">';
			$html .= 'Iepriekðçjâ';
			$html .= '</a> ';
		}

		for($i=1; $i<=$this->getNumPages(); $i++) {
			if ($i != $this->currPage) {
				$html .= ' <a href="'.$baseUrl.'?'.$pageVar.'='.$i.'">['.$i.']</a> ';
			} else {
				$html .= ' ['.$i.'] ';
			}
		}

		if ($this->hasNext()) {
			$html .= ' <a href="'.$baseUrl.'?'.$pageVar.'='.($this->currPage+1).'">';
			$html .= 'Nâkamâ';
			$html .= '</a>';
		}

		return $html;
	}

	public function hasPrev()
	{
		if ($this->currPage > 1) {
			return true;
		} else {
			return false;
		}
	}

	public function hasNext()
	{
		

		if ($this->currPage < $this->getNumPages()) {
			return true;
		} else {
			return false;
		}
	}

	public function getNumPages()
	{
		$numPages = ceil($this->totalItems/$this->itemsPerPage);

		return $numPages;
	}	
}
?>
